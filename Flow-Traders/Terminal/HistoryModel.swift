//
//  HistoryModel.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import Foundation
import SwiftDate

struct HistoryModel {
    
    var name: String
    var time: Date
    
    var timeString: String {
        return time.toString(.custom("yyyy-MM-dd HH:mm:ss"))
    }
    
    var timeIsPassed: Bool {
        return time.isInPast
    }
}
