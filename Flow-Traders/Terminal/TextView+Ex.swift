//
//  TextView+Ex.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 30.9.22.
//

import Foundation
import UIKit

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}
