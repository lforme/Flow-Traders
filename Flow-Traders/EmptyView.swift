//
//  EmptyView.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.font = UIFont.pixelFont(with: 16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
