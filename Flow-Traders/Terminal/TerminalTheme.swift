//
//  TerminalTheme.swift
//  8ce26f
//
//  Created by DZSB-001968 on 12.10.21.
//

import Foundation
import SavannaKit

class TerminalTheme: SyntaxColorTheme {
    
    private static var lineNumbersColor: Color {
        return Color(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    }
    let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: UIFont.pixelFont(with: 16), textColor: lineNumbersColor)
    
    let gutterStyle: GutterStyle = GutterStyle(backgroundColor: UIColor(hex: "#252525"), minimumWidth: 32)
    
    let font = UIFont.pixelFont(with: 15)
    
    let backgroundColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
    
    func globalAttributes() -> [NSAttributedString.Key: Any] {
        
        var attributes = [NSAttributedString.Key: Any]()
        
        attributes[.font] = UIFont.pixelFont(with: 15)
        attributes[.foregroundColor] = UIColor(hex: "#00FD34")
        
        return attributes
    }
    
    func attributes(for token: Token) -> [NSAttributedString.Key: Any] {
        
        guard let myToken = token as? TerminalToken else {
            return [:]
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributes[.paragraphStyle] = paragraphStyle
        
        switch myToken.type {
            
        case .some(.history), .some(.help):
            attributes[.foregroundColor] = UIColor(hex:"#F9F1A5")
        case .some(.clearAll):
            attributes[.foregroundColor] = UIColor.red
        case .some(.customs(_)):
            break
        case .none:
            break
        }
        
        return attributes
    }
    
}
