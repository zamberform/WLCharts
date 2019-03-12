//
//  WLPieChart.swift
//  wlcharts
//
//  Created by ZamberForm on 2019/03/04.
//  Copyright © 2019 Sakiki. All rights reserved.
//

import UIKit

open class WLPiechart: UIView {
    fileprivate var total: Double = 0
    
    public var isDonuts: Bool = true
    public var donutsPercent: Double = 0.5
    public var isAnimation: Bool = true
    public var animeDuration: Double = 1.0
    
    open var slices: [WLPieSlice] = [] {
        didSet {
            total = 0
            for slice in slices {
                total = slice.value + total
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        backgroundColor = .clear
    }
    
    open override func draw(_ rect: CGRect) {
        
//        if (self.layer.sublayers?.count)! > 0 {
//            for view: AnyObject in self.layer.sublayers! {
//                view.removeAllAnimations()
//                view.removeFromSuperlayer()
//            }
//        }
        
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let outerRadius = min(bounds.width / 2, bounds.height / 2)
        let innerRadius = (1 - donutsPercent) * Double(outerRadius)
        var startValue: Double = 0
        var startAngle: Double = 0
        var endValue: Double = 0
        var endAngle: Double = 0
        
        for (_, slice) in slices.enumerated() {
            
            startAngle = (startValue * 2 * Double.pi) - Double.pi / 2
            endValue = startValue + slice.value / self.total
            endAngle = (endValue * 2 * Double.pi) - Double.pi / 2
            
            let outerCircle = CAShapeLayer()
            
            let path = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            outerCircle.lineWidth = outerRadius
            outerCircle.fillColor = UIColor.white.cgColor
            outerCircle.strokeColor = slice.color.cgColor
            outerCircle.path = path.cgPath
            
            self.layer.addSublayer(outerCircle)
            
            startValue += slice.value / self.total
            
            if isAnimation {
                runPieAnimation(layer: outerCircle)
            }
        }
        
        if !isDonuts {
            return
        }
        
        let innerCircle = CAShapeLayer()
        
        let path = UIBezierPath(arcCenter: center, radius: CGFloat(innerRadius), startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        innerCircle.lineWidth = CGFloat(innerRadius)
        innerCircle.fillColor = UIColor.white.cgColor
        innerCircle.strokeColor = UIColor.white.cgColor
        innerCircle.path = path.cgPath
        self.layer.addSublayer(innerCircle)
    }
    
    private func runPieAnimation(layer: CAShapeLayer) {
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        drawAnimation.duration = animeDuration
        
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        drawAnimation.isRemovedOnCompletion = true
        drawAnimation.fillMode = kCAFillModeForwards;
        layer.add(drawAnimation, forKey: "updateGageAnimation")
    }
}

