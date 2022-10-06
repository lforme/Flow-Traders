//
//  NormalFooter.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import Foundation
import MJRefresh
import SnapKit

public class NormalFooter: MJRefreshAutoStateFooter {
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.font = UIFont.pixelFont(with: 14)
        return l
    }()
    
    public override func prepare() {
        super.prepare()
        
        addSubview(label)
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        
        label.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stateLabel?.isHidden = true
    }

    public override var state: MJRefreshState {
        didSet {
            
            switch state {
            case .idle:
                label.isHidden = true
                
            case .pulling, .refreshing, .willRefresh:
                refreshStyle()
                
            case .noMoreData:
                nomoreDataStyle()
                
            @unknown default:
                label.isHidden = true
            }
        }
    }
    
    func refreshStyle() {
        label.isHidden = false
        label.textColor = UIColor(hex: "#111111")
        label.text = "Loading..."
    }
    

    func nomoreDataStyle() {
        label.isHidden = false
        label.text = "- no more data -"
        label.textColor = UIColor(hex: "#999999")
    }
}
