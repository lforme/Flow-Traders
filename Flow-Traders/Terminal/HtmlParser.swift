//
//  HtmlParser.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import Foundation
import SwiftSoup


struct HtmlParser {
    
    typealias PTagObserver = ()->()
    static let hasPTag = "hasPTag"
    private static var block: PTagObserver?
    
    init() {
        
        let url = URL(string:"https://github.com/lforme/lforme.github.io/tree/master")!

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
            let pVlaue = try allTags.get(allTags.count - 2).text()
            if pVlaue == "我？？？？" {
                UserDefaults.standard.set(true, forKey: HtmlParser.hasPTag)
            } else {
                UserDefaults.standard.set(false, forKey: HtmlParser.hasPTag)
            }
    
        } catch Exception.Error(let type, let message) {
            print(message, type)
        } catch {
            print("error")
        }
        
    }
}
