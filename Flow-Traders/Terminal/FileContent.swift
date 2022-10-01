//
//  FileContent.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 30.9.22.
//

import Foundation

struct FileContent {
    
    static let content: [String: String] = [
        "1": "输入help查看帮助",
        "help": """
        如何创建任务:
        -t 20201020 1022
        -m 提醒我喝水 \n
        如何查看任务:
        history \n
        """,
        "2": """
        请输入任务名称:
        """,
        "3": """
        任务创建成功!☕️☕️☕️✅
        """,
    ]
}
