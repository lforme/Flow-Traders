//
//  TerminalLexer.swift
//  8ce26f
//
//  Created by DZSB-001968 on 13.10.21.
//

import Foundation
import SavannaKit
import SwiftDate

class CustomLexer: TerminalLexer {
    
    typealias ExecuteHandle = (TerminalCommand?) -> Void
    
    private var command: TerminalCommand?
    private var executeBlock: ExecuteHandle?
    static let shortcutCommand = ["-r","-m"]
    private let regularExpression = try? NSRegularExpression(pattern: matchPattern(with: shortcutCommand), options: .allowCommentsAndWhitespace)
    var endTime: Date?
    var processIndex: String?
    
    init() {}
    
    func execute(handle: ((TerminalCommand?) -> Void)?) {
        executeBlock = handle
    }
    
    func getSavannaTokens(input: String) -> [Token] {
        
        
        var tokens = [TerminalToken]()
        
        input.enumerateSubstrings(in: input.startIndex..<input.endIndex, options: [.byWords]) { (word, range, _, _) in
            
            if let word = word {
                
                var token = TerminalToken(type: nil, isEditorPlaceholder: false, isPlain: false, range: range)
                
                switch word {
                case "help":
                    token.type = TerminalCommand.help
                case "history":
                    token.type = TerminalCommand.history
                case "clearall":
                    token.type = TerminalCommand.clearAll
                default:
                    break
                }
                
                tokens.append(token)
            }
        }
        
        let commandLines = input.components(separatedBy: "\n")
        if commandLines.last?.isEmpty ?? false {
            if let runIndex = commandLines.lastIndex(of: "") {
                let prepareExecute = commandLines[runIndex - 1]
                
                
                switch prepareExecute {
                case "help":
                    executeBlock?(TerminalCommand.help)
                case "history":
                    executeBlock?(TerminalCommand.history)
                case "clearall":
                    executeBlock?(TerminalCommand.clearAll)
                    
                default:
                    if prepareExecute.contains("-t") {
                        
                        guard let date = prepareExecute.replacingOccurrences(of: "-t ", with: "").toDate(style: .custom("yyyyMMdd HHmm"))?.date else {
                            break
                        }
                        
                        
                        if date.isInPast {
                            break
                        }
                        processIndex = "2"
                        let cmd = TerminalCommand.customs(TerminalCommand.Operation.time(processIndex!))
                        executeBlock?(cmd)
                        endTime = date
                    }
                    
                    if prepareExecute.contains("-m") && endTime != nil {
                        
                        let msgStr = prepareExecute.replacingOccurrences(of: "-m ", with: "")
                        
                        if msgStr.isEmpty {
                            break
                        }
                        processIndex = "3"
                        
                        let cmd = TerminalCommand.customs(TerminalCommand.Operation.message(endTime!, msgStr, processIndex!))
                        executeBlock?(cmd)
                        processIndex = nil
                        endTime = nil
                    }
                    
                }
            }
        }
        
        return tokens
    }
    
}

private extension TerminalLexer {
    
    static func matchPattern(with items: [String]) -> String {
        if items.isEmpty {
            return ""
        }
        if items.count == 1 {
            return "(?<=\(items[0])[\\s\\S]*$"
        }
        var results: [String] = []
        for i in 0..<items.count {
            if (i + 1) >= items.count {
                results.append("(?<=\(items[i]))[\\s\\S]*$")
            } else {
                results.append("(?<=\(items[i]))[\\s\\S]*?(?=\(items[i+1]))")
            }
        }
        
        return results.joined(separator: "|")
    }
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
