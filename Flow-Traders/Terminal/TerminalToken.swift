//
//  TerminalToken.swift
//  8ce26f
//
//  Created by DZSB-001968 on 13.10.21.
//

import Foundation
import SavannaKit
import SwiftDate

struct TerminalToken: Token {
    
    var type: TerminalCommand?
    
    let isEditorPlaceholder: Bool
    
    let isPlain: Bool
    
    let range: Range<String.Index>
        
}
