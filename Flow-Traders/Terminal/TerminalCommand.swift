//
//  TerminalCommand.swift
//  8ce26f
//
//  Created by DZSB-001968 on 13.10.21.
//

import Foundation


enum TerminalCommand {
    
    enum Operation {
        case time(String)
        case message(Date, String, String)
    }
    
    case help
    case history
    case clearAll
    case customs(Operation)
}
