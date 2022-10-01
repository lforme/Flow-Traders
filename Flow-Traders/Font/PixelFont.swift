//
//  PixelFont.swift
//  8ce26f
//
//  Created by DZSB-001968 on 12.10.21.
//

import Foundation
import UIKit

extension UIFont {
    
    @discardableResult
    static func pixelFont(with fontSize: CGFloat) -> UIFont {
        guard let name = UIFont.fontNames(forFamilyName: "FZXS12").last else {
            fatalError("找不到字体")
        }
        
        guard let customFont = UIFont(name: name, size: fontSize) else {
            fatalError("找不到字体")
        }
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
