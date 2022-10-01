//
//  TerminalDescriptionConfig.swift
//  8ce26f
//
//  Created by DZSB-001968 on 12.10.21.
//

import Foundation
import SwiftDate
import UIKit

class TerminalDescriptionConfig: NSObject {
    
    var loginWelcome: String {
        return "Last login \(Date().toString(.custom("yyyy-MM-dd HH:mm"))) on $\n"
    }
}
