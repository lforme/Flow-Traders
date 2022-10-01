//
//  NormalRefreshHeader.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import Foundation
import UIKit
import MJRefresh
import SnapKit

public class NormalRefreshHeader: MJRefreshHeader {
    
    private lazy var iconImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "tvrefresh_loading"))
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var animation: CABasicAnimation = {
        let a = CABasicAnimation(keyPath: "transform.rotation.z")
        a.fromValue = 0
        a.toValue = Double.pi*2
        a.duration = 2
        a.speed = 4
        a.autoreverses = false
        a.isRemovedOnCompletion = false
        a.fillMode = CAMediaTimingFillMode.forwards
        a.repeatCount = MAXFLOAT
        a.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        return a
    }()
    
    private lazy var stop: Bool = false
    
    public override func prepare() {
        super.prepare()
        
        backgroundColor = UIColor.clear
        addSubview(iconImageView)
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        
        iconImageView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public override var state: MJRefreshState {
        didSet {
            if state == .idle {
                stopAnimation()
            }
            if state == .pulling {
                prepareAnimation()
            }
            if state == .refreshing {
                stop = false
                startAnimation()
            }
        }
    }
    
    func startAnimation() {
        let pauseTime = iconImageView.layer.timeOffset
        iconImageView.layer.speed = 1.0
        iconImageView.layer.timeOffset = 0.0
        iconImageView.layer.beginTime = 0.0
        let timeSincePause = iconImageView.layer.convertTime(CACurrentMediaTime(), to: nil) - pauseTime
        iconImageView.layer.beginTime = timeSincePause
    }
    
    func stopAnimation() {
        let pauseTime = iconImageView.layer.convertTime(CACurrentMediaTime(), to: nil)
        iconImageView.layer.speed = 0.0
        iconImageView.layer.timeOffset = pauseTime
    }
    
    func prepareAnimation() {
        iconImageView.layer.removeAnimation(forKey: "iconImageViewAnimation")
        iconImageView.layer.add(animation, forKey: "iconImageViewAnimation")
    }
}
