//
//  RadarChart.swift
//  SwiftyChartDemo
//
//  Created by ZamberForm on 2016/11/16.
//
//

import UIKit

public class WLRadarChart : UIView {
    
    public var isShowGraduation: Bool = false
    public var valueDivider: Double = 1.0
    public var maxValue: Double = 1
    public var radarLineWidth: Double = 1
    public var colors: WLRadarColor = WLRadarColor()
    public var fontSize: Double = 15
    public var isAnimation: Bool = true
    
    private var pointsToWebArray: [[CGPoint]] = [[]]
    private var pointsToPlotArray: [CGPoint] = []
    private var lengthUnit: Double = 0
    private var chartPlot: CAShapeLayer = CAShapeLayer()
    private var chartData: [WLRadarValue] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        
        chartPlot.removeAllAnimations()
        chartPlot.removeFromSuperlayer()
        
        chartPlot = CAShapeLayer()
        
        chartPlot.lineCap = kCALineCapButt
        chartPlot.fillColor = colors.plotColor.cgColor
        chartPlot.lineWidth = CGFloat(radarLineWidth)
        layer.addSublayer(chartPlot)
        
        
        if chartData.count <= 0 {
            return
        }
        calculateChartPoints()
        
        var section = 0
        for pointArray in pointsToWebArray {
            context?.beginPath()
            let beginPoint = pointArray[0]
            
            context?.move(to: beginPoint)
            
            for point in pointArray {
                context?.addLine(to: point)
            }
            
            context?.addLine(to: beginPoint)
            context?.setStrokeColor(colors.webColor.cgColor)
            context?.strokePath()
        }
        
        for point in pointsToWebArray.last! {
            section += 1
            
            if section == 1 && isShowGraduation {
                continue
            }
            
            context?.beginPath()
            context?.move(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2))
            context?.addLine(to: point)
            context?.setStrokeColor(colors.webColor.cgColor)
            context?.strokePath()
        }
        
        chartPlot.removeAllAnimations()
        
        let plotLine = UIBezierPath()
        let beginPoint = pointsToPlotArray[0]
        
        plotLine.move(to: beginPoint)
        
        for pointValue in pointsToPlotArray {
            plotLine.addLine(to: pointValue)
        }
        
        plotLine.lineWidth = CGFloat(radarLineWidth)
        plotLine.lineCapStyle = .butt
        
        chartPlot.path = plotLine.cgPath
        
        if isAnimation {
            addAnimationIfNeeded()
        }
        showGraduation()
    }
    
    public func addRadarDatas(_ datas: [WLRadarValue]) {
        chartData = datas
        setNeedsDisplay()
    }
    
    private func addAnimationIfNeeded() {
        let animateScale = CABasicAnimation(keyPath: "transform.scale")
        animateScale.fromValue = 0
        animateScale.toValue = 1
        
        let animateMove = CABasicAnimation(keyPath: "position")
        animateMove.fromValue = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        animateMove.toValue = CGPoint(x: 0, y: 0)
        
        let animateAlpha = CABasicAnimation(keyPath: "opacity")
        animateAlpha.fromValue = 0
        
        let animeGroup = CAAnimationGroup()
        animeGroup.duration = 1
        animeGroup.repeatCount = 1
        animeGroup.animations = [animateScale, animateMove, animateAlpha]
        animeGroup.isRemovedOnCompletion = true
        
        chartPlot.add(animeGroup, forKey: nil)
    }
    
    private func showGraduation() {
        let label = viewWithTag(111)
        if label != nil {
            label?.removeFromSuperview()
        }
        
        var section = 0.0
        for points in pointsToWebArray {
            section = section + 1
            
            let labelPoint = points[0]
            
            let graduationLabel = UILabel(frame: CGRect(x: Double(labelPoint.x) - lengthUnit, y: Double(labelPoint.y) - lengthUnit * 5 / 8, width: lengthUnit * 5 / 8, height: lengthUnit))
            graduationLabel.adjustsFontSizeToFitWidth = true
            graduationLabel.tag = 111
            graduationLabel.font = UIFont.systemFont(ofSize: CGFloat(lengthUnit))
            graduationLabel.textColor = .orange
            graduationLabel.text = String.init(format: "%.0f", valueDivider * section)
            
            addSubview(graduationLabel)
            
            if isShowGraduation {
                graduationLabel.isHidden = false
            }
            else {
                graduationLabel.isHidden = true
            }
        }
    }
    
    private func calculateChartPoints() {
        pointsToPlotArray.removeAll()
        pointsToWebArray.removeAll()
        
        var descriptions : Array<String> = []
        var values: [Double] = []
        var angles: [Double] = []
        
        for i in 0...(chartData.count - 1) {
            descriptions.append(chartData[i].text)
            values.append(chartData[i].value)
            
            angles.append(Double(i) / Double(chartData.count) * (2.0 * Double.pi) )
        }
        
        maxValue = getMaxValueFromArray(values: values)
        
        let margin = getMaxWidthLabelFromArray(descriptions: descriptions, fontSize: fontSize)
        let maxLength = Double(fmin(bounds.width / 2, bounds.height / 2)) - margin
        
        var plotCircles = maxValue / valueDivider
        if !(plotCircles.isLessThanOrEqualTo(20)) {
            plotCircles = 20
            valueDivider = maxValue / 20
        }
        
        lengthUnit = maxLength / plotCircles
        
        let lengthArray = getLengthArrayWithCircleNum(plotCircles: plotCircles)
        
        for lengthNumber in lengthArray {
            pointsToWebArray.append(getWebPointWithLength(length: lengthNumber, angleArray: angles))
        }
        
        var section = 0
        for value in values {
            if value > maxValue {
                return
            }
            
            let length = value / maxValue * maxLength
            let angle = angles[section]
            
            pointsToPlotArray.append(CGPoint(x: Double(bounds.width / 2) + length * cos(angle), y: Double(bounds.height / 2) + length * sin(angle)))
            section += 1
        }
        
        drawLabelWithMaxLength(maxLength: maxLength, labelArray: descriptions, angleArray: angles)
    }
    
    private func drawLabelWithMaxLength(maxLength: Double, labelArray: [String], angleArray: [Double]) {
        let label = viewWithTag(1111)
        if label != nil {
            label?.removeFromSuperview()
        }
        
        var section = 0
        let labelLength = maxLength * 1.1
        
        for labelString in labelArray {
            let angle = angleArray[section]
            
            let x = Double(bounds.width / 2) + labelLength * cos(angle)
            let y = Double(bounds.height / 2) + labelLength * sin(angle)
            
            let label = UILabel()
            label.backgroundColor = .clear
            label.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            label.text = labelString
            label.tag = 1111
            
            let labelNS = labelString as NSString
            let detailSize = labelNS.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: CGFloat(fontSize))])
            
            if x < Double(bounds.width / 2) {
                label.frame = CGRect(x: x - Double(detailSize.width), y: y - Double(detailSize.height / 2), width: Double(detailSize.width), height: Double(detailSize.height))
                label.textAlignment = .right
            }
            else {
                label.frame = CGRect(x: x, y: y - Double(detailSize.height / 2), width: Double(detailSize.width), height: Double(detailSize.height))
                label.textAlignment = .left
            }
            
            label.sizeToFit()
            addSubview(label)
            
            section += 1
        }
    }
    
    private func getWebPointWithLength(length: Double, angleArray: [Double]) -> [CGPoint] {
        var pointArray: [CGPoint] = []
        for angleNumber in angleArray {
            pointArray.append(CGPoint(x: Double(bounds.width / 2) + length * cos(angleNumber), y: Double(bounds.height / 2) + length * sin(angleNumber)))
        }
        
        return pointArray
    }
    
    private func getLengthArrayWithCircleNum(plotCircles: Double) -> [Double] {
        var lengthArray: [Double] = []
        
        var length:Double = 0
        for _ in 0...Int(plotCircles - 1) {
            length += lengthUnit;
            lengthArray.append(length)
        }
        
        return lengthArray
    }
    
    private func getMaxWidthLabelFromArray(descriptions: [String], fontSize : Double) -> Double {
        var maxWidth: Double = 0
        for str in descriptions {
            let detail: NSString = str as NSString
            let detailSize: CGSize = detail.size(withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: CGFloat(fontSize))])
            maxWidth = fmax(maxWidth, Double(detailSize.width))
        }
        
        return maxWidth
    }
    
    private func getMaxValueFromArray(values : [Double]) -> Double {
        var max = maxValue
        for number in values {
            max = fmax(number, max)
        }
        
        return max
    }
    
}
