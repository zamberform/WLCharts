//
//  WLCircularChart.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/12.
//

import UIKit

@IBDesignable
public class WLCircularChart: UIView {
    
    var bgPathTopLevel:UIBezierPath!
    var topLevelShapeLayer:CAShapeLayer!
    var topLevelProgressLayer:CAShapeLayer!
    var chartText = UILabel()
    
    private var progress: Double = 0.0
    
    @IBInspectable
    public var displayProgress: Double = 0.0 {
        willSet(newValue) {
            
            topLevelProgressLayer.strokeEnd = CGFloat(newValue)
            var preogressStr = ""
            if (0 ... 1).contains(newValue){
                preogressStr = String.init(format: "%d%@", Int(newValue*100),"%")
            }else {
                preogressStr = String.init(format: "%d%@", 100,"%")
            }
            self.chartText.text = preogressStr
        }
    }
    
    @IBInspectable
    public var fontColor: UIColor? = nil {
        willSet(newColor) {
            chartText.textColor = newColor
        }
    }
    
    public var displayFont: UIFont? = nil {
        willSet(newFont) {
            chartText.font = newFont
        }
    }
    
    @IBInspectable var outerThickness:Double  = 5.0 {
        willSet(newValue){
            
            topLevelShapeLayer.lineWidth = CGFloat(newValue)
            topLevelProgressLayer.lineWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var outerProgressColor:UIColor = UIColor.blue {
        willSet(newValue){
            topLevelProgressLayer.strokeColor = newValue.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        simpleShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        simpleShape()
    }
    
    override open func draw(_ rect: CGRect) {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi/2) * -1));
        self.backgroundColor = UIColor.clear
    }
    
    private func createCirclePath() {
        let x = self.bounds.width/2
        let y = self.bounds.height/2
        
        let center = CGPoint(x: x, y: y)
        
        bgPathTopLevel = UIBezierPath.init()
        
        bgPathTopLevel.addArc(withCenter: center, radius: x-10, startAngle: CGFloat(0), endAngle: CGFloat(2*(Double.pi)), clockwise: true)
        
        bgPathTopLevel.close()
        
        chartText.frame = CGRect.init(x: 0, y: 0, width:x, height: x)
        
        chartText.text = "0%"
        chartText.textAlignment = .center
        self.addSubview(chartText)
        chartText.backgroundColor = UIColor.clear
        chartText.center = CGPoint(x: x, y: y)
        chartText.font = UIFont.systemFont(ofSize:(x-30)/2 )
        chartText.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi/2)))
    }
    
    
    func simpleShape() {
        createCirclePath()
        
        topLevelShapeLayer = CAShapeLayer()
        topLevelShapeLayer.path = bgPathTopLevel.cgPath
        topLevelShapeLayer.lineWidth = CGFloat(outerThickness)
        topLevelShapeLayer.fillColor = nil
        topLevelShapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        topLevelProgressLayer = CAShapeLayer()
        topLevelProgressLayer.path = bgPathTopLevel.cgPath
        topLevelProgressLayer.lineWidth = CGFloat(outerThickness)
        topLevelProgressLayer.lineCap = kCALineCapSquare
        topLevelProgressLayer.fillColor = nil
        topLevelProgressLayer.strokeColor = outerProgressColor.cgColor
        topLevelProgressLayer.strokeEnd = CGFloat(progress)
        
        self.layer.addSublayer(topLevelShapeLayer)
        self.layer.addSublayer(topLevelProgressLayer)
    }
    
}
