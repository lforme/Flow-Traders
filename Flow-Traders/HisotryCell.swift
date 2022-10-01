//
//  HisotryCell.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import UIKit

class HisotryCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = UIFont.pixelFont(with: 14)
        }
    }
    @IBOutlet weak var taskLabel: UILabel! {
        didSet {
            taskLabel.font = UIFont.pixelFont(with: 17)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskLabel.attributedText = nil
        timeLabel.attributedText = nil
        
        taskLabel.text = nil
        timeLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bindModel(item: HistoryModel) {
        if item.timeIsPassed {
            let nameAttribute: NSMutableAttributedString = NSMutableAttributedString(string: item.name)
            nameAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: nameAttribute.length))
            taskLabel.attributedText = nameAttribute
            
            let timeAttribute: NSMutableAttributedString = NSMutableAttributedString(string: item.timeString)
            timeAttribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: timeAttribute.length))
            timeLabel.attributedText = timeAttribute
        } else {
            
            taskLabel.text = item.name
            timeLabel.text = item.timeString
        }
    }
}
