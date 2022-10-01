//
//  DBTool.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 30.9.22.
//

import Foundation
import SQLite
import SwiftDate

final class MetaDb {
    
    let path: String
    var db: Connection?
    var table: Table
    
    static let id = Expression<Int64>("id")
    static let taskName = Expression<String>("taskName")
    static let endTime = Expression<Date>("endTime")

    private var offset = 0
    private var lock = pthread_rwlock_t()
    private let queue = DispatchQueue(label: "com.networkMetaDb.rw", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem)
    private let kDatabaseName = "taskdb.sqlite3"
    private let kTableName = "Tasks"
    
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    init() {
        
        var documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        if documentsDirectory.last! != "/" {
            documentsDirectory.append("/")
        }
        
        self.path = documentsDirectory.appending(kDatabaseName)
        self.table = Table(kTableName)
        initDb()
    }
    
    fileprivate func initDb() {
        do {
            self.db = try Connection(self.path)
            print("db path: \(self.path)")
        } catch {
            print(error.localizedDescription)
        }
        assert(self.db != nil)
        createTable()
    }
    
    fileprivate func createTable() {
        try! self.checkDb().run(self.table.create(ifNotExists: true) { t in
            t.column(MetaDb.id, primaryKey: .autoincrement)
            t.column(MetaDb.endTime, unique: true)
            t.column(MetaDb.taskName)
        })
    }
    
    fileprivate func checkDb() -> Connection {
        guard let _db = self.db else {
            fatalError("db can not open")
        }
        return _db
    }
}

extension MetaDb {
    
    @discardableResult
    func save(_ time: Date, content: String) -> Bool {
        var result = false
        pthread_rwlock_trywrlock(&lock)
        do {
            try db?.transaction {
                let filterTable = self.table.filter(MetaDb.endTime == time)
                if try self.checkDb().run(filterTable.update(
                    MetaDb.endTime <- time,
                    MetaDb.taskName <- content
                )) > 0 {
                    result = true
                    pthread_rwlock_unlock(&lock)
                } else {
                    
                    let rowid = try self.checkDb().run(self.table.insert(
                        MetaDb.taskName <- content,
                        MetaDb.endTime <- time
                    ))
                    result = (rowid > Int64(0)) ? true : false
                    pthread_rwlock_unlock(&lock)
                }
            }
            
        } catch {
            pthread_rwlock_unlock(&lock)
            result = false
            print(error.localizedDescription)
            
        }
        return result
    }
    
    @discardableResult
    func fetch(isNew: Bool) -> [Row] {
        
        return aroundRd {
            
            if isNew {
                offset = 0
            } else {
                offset += 15
            }
            
            let query = table.select(table[*])
                .order(MetaDb.id.desc)
                .limit(15, offset: offset)
            
            do {
                
                let rows = try checkDb().prepare(query)
                
                let array = Array(rows)
                
                return array
                
            } catch  {
                print(error.localizedDescription)
                return []
            }
        }
        
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        
        return aroundWr {
            var result = -1
            do {
                result = try checkDb().run(table.delete())
                
            } catch {
                print("delete failed: \(error)")
                result = -1
                
            }
            return result > 0
        }
    }
}

extension MetaDb {
    
    func aroundRd<T>(_ closure: () -> T) -> T {
        pthread_rwlock_tryrdlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return closure()
    }
    
    func aroundWr<T>(_ closure: () -> T) -> T {
        pthread_rwlock_trywrlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return closure()
    }
}
