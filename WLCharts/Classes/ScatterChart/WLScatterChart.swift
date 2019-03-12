//
//  SWScatterChart.swift
//  SwiftyChartDemo
//
//  Created by ZamberForm on 2016/11/16.
//
//

import UIKit

fileprivate struct WLScatterVector {
    var size: Double = 0
    var steps: Double = 0
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
}

public class WLScatterChart: UIView {
    
    public var isAnimation: Bool = true
    public var animeDuration: Double = 1
    public var xAxis: WLScatterAxis = WLScatterAxis()
    public var yAxis: WLScatterAxis = WLScatterAxis()
    public var fontInfo: WLScatterFont = WLScatterFont()
    
    private var chartDatas: [WLScatterValue] = []
    private var horizentalLinepathLayer : [CAShapeLayer] = []
    private var verticalLineLayer : [CAShapeLayer] = []
    
    private var pathLayer : CAShapeLayer = CAShapeLayer()
    
    private var startPoint : CGPoint = CGPoint.zero
    
    private var vectorX: WLScatterVector = WLScatterVector()
    private var vectorY: WLScatterVector = WLScatterVector()
    private var isForUpdate : Bool = false
    
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
    
    private func setUpVectors() {
        startPoint = CGPoint(x: xAxis.margin, y: Double(bounds.height) - yAxis.margin)
        vectorXSetup()
        vectorYSetup()
    }
    
    private func vectorXSetup() {
        vectorX.size = Double(bounds.width) - xAxis.margin - 15
        vectorX.steps = vectorX.size / Double(xAxis.partNumber)
        vectorX.endPoint = CGPoint(x: startPoint.x + CGFloat(vectorX.size), y: startPoint.y)
        vectorX.startPoint = startPoint
    }
    
    private func vectorYSetup() {
        vectorY.size = Double(bounds.height) - yAxis.margin - 15
        vectorY.steps = vectorY.size / Double(yAxis.partNumber)
        vectorY.endPoint = CGPoint(x: startPoint.x, y: startPoint.y - CGFloat(vectorY.size))
        vectorY.startPoint = startPoint
    }
    
    private func calculateXLabels() {
        
        
        var labelFormat : String?
        if !(xAxis.labelFormat.isEmpty) {
            labelFormat = xAxis.labelFormat
        }
        else {
            labelFormat = "%1.f"
        }
        
        xAxis.labels.append(String.init(format: labelFormat!, xAxis.minValue))
        
        var tempValue = xAxis.minValue
        for _ in 0...(xAxis.partNumber - 2) {
            tempValue = tempValue + xAxis.step
            
            xAxis.labels.append(String.init(format: labelFormat!, tempValue))
        }
    }
    
    
    private func calculateYLabels() {
        
        
        var labelFormat : String?
        if !(yAxis.labelFormat.isEmpty) {
            labelFormat = yAxis.labelFormat
        }
        else {
            labelFormat = "%1.f"
        }
        
        yAxis.labels.append(String.init(format: labelFormat!, yAxis.minValue))
        
        var tempValue = yAxis.minValue
        for _ in 0...(yAxis.partNumber - 2) {
            tempValue = tempValue + yAxis.step
            yAxis.labels.append(String.init(format: labelFormat!, tempValue))
        }
    }
    
    public func getAxisMinMax(xValues : [Double]) -> [Double] {
        var min = xValues[0]
        var max = xValues[0]
        
        for number in xValues {
            if number > max {
                max = number
            }
            
            if number < min {
                min = number
            }
        }
        
        return [min, max]
    }
    
    public func showLabel(description: String, point:CGPoint) {
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.frame = CGRect(x: point.x, y: point.y, width: 30, height: 10)
        descriptionLabel.font = fontInfo.descriptionTextFont
        descriptionLabel.textColor = fontInfo.descriptionTextColor
        descriptionLabel.shadowColor = fontInfo.descriptionTextShadowColor
        descriptionLabel.shadowOffset = fontInfo.descriptionTextShadowOffset
        descriptionLabel.textAlignment = .center
        descriptionLabel.backgroundColor = .clear
        
        addSubview(descriptionLabel)
    }
    
    open func setScatterDatas(_ datas: [WLScatterValue]) {
        chartDatas = datas
        setNeedsDisplay()
    }
    
    private func mappingIsForAxis(isForAxisX : Bool, value: Double) -> Double {
        if isForAxisX {
            let temp = Double(vectorX.startPoint.x) + vectorX.steps / 2
            let xPos = temp + ( ( value - xAxis.minValue ) / xAxis.step ) * vectorX.steps
            return xPos
        }
        else {
            let temp = Double(vectorY.startPoint.y) - vectorY.steps / 2
            let yPos = temp - ( ( value - yAxis.minValue ) / yAxis.step ) * vectorY.steps
            return yPos
        }
    }
    
    private func drawingPointsForChartData(charaData: WLScatterValue, x:Double, y:Double) -> CAShapeLayer {
        let radius = charaData.size
        let circle = CAShapeLayer()
        circle.path = UIBezierPath.init(roundedRect: CGRect(x: x-radius, y: y-radius, width: 2*radius, height: 2*radius), cornerRadius: CGFloat(radius)).cgPath
        circle.fillColor = charaData.fillColor.cgColor
        circle.strokeColor = charaData.strokeColor.cgColor
        circle.lineWidth = 1
        return circle
    }
    
    private func addAnimationIfNeeded() {
        if isAnimation {
            let pathAnimation = CABasicAnimation.init()
            pathAnimation.duration = animeDuration
            pathAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1
            pathAnimation.fillMode = kCAFillModeForwards
            layer.opacity = 1
            pathLayer.add(pathAnimation, forKey: "fade")
        }
    }
    
    private func showXLables() {
        if xAxis.labels.count <= 0 || xAxis.labels.isEmpty || xAxis.labels.count != xAxis.partNumber {
            calculateXLabels()
        }
        
        var temp = vectorX.startPoint.x + CGFloat(vectorX.steps) * 0.5
        
        for i in 0...(xAxis.labels.count - 1) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: temp, y: vectorX.startPoint.y - 2))
            path.addLine(to: CGPoint(x: temp, y: vectorX.startPoint.y + 3))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = xAxis.color.cgColor
            shapeLayer.lineWidth = CGFloat(xAxis.width)
            shapeLayer.fillColor = xAxis.color.cgColor
            
            self.horizentalLinepathLayer.append(shapeLayer)
            
            layer.addSublayer(shapeLayer)
            let lb = xAxis.labels[i]
            showLabel(description: lb, point: CGPoint(x: temp - 15, y: vectorX.startPoint.y + 10))
            
            temp = temp + CGFloat(vectorX.steps)
        }
    }
    
    private func showYLables() {
        if yAxis.labels.count <= 0 || yAxis.labels.isEmpty || yAxis.labels.count != yAxis.partNumber {
            calculateYLabels()
        }
        
        var temp = vectorY.startPoint.y - CGFloat(vectorY.steps) * 0.5
        
        for i in 0...(yAxis.labels.count - 1) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: vectorY.startPoint.x - 3, y: temp))
            path.addLine(to: CGPoint(x: vectorY.startPoint.x + 2, y: temp))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = yAxis.color.cgColor
            shapeLayer.lineWidth = CGFloat(yAxis.width)
            shapeLayer.fillColor = yAxis.color.cgColor
            
            self.verticalLineLayer.append(shapeLayer)
            
            layer.addSublayer(shapeLayer)
            
            let lb = yAxis.labels[i]
            showLabel(description: lb, point: CGPoint(x: vectorY.startPoint.x - 30, y: temp - 5))
            temp = temp - CGFloat(vectorY.steps)
        }
    }
    
    override open func draw(_ rect: CGRect) {
        
        setUpVectors()
        
        for layer in horizentalLinepathLayer {
            layer.removeFromSuperlayer()
        }
        
        for layer in verticalLineLayer {
            layer.removeFromSuperlayer()
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        
        if xAxis.showAxis {
            
            context?.setStrokeColor(xAxis.color.cgColor);
            context?.setLineWidth(CGFloat(xAxis.width))
            context?.move(to: startPoint)
            context?.addLine(to: vectorX.endPoint)
            
            context?.move(to: vectorX.endPoint)
            context?.addLine(to: CGPoint(x:vectorX.endPoint.x - 5, y: vectorX.endPoint.y + 3))
            context?.move(to: vectorX.endPoint)
            context?.addLine(to: CGPoint(x: vectorX.endPoint.x - 5, y: vectorX.endPoint.y - 3))
        }
        
        if yAxis.showAxis {
            context?.setStrokeColor(yAxis.color.cgColor);
            context?.setLineWidth(CGFloat(yAxis.width))
            context?.move(to: startPoint)
            context?.addLine(to: vectorY.endPoint)
            
            context?.move(to: vectorY.endPoint)
            context?.addLine(to: CGPoint(x: vectorY.endPoint.x - 3, y: vectorY.endPoint.y + 5))
            context?.move(to: vectorY.endPoint)
            context?.addLine(to: CGPoint(x: vectorY.endPoint.x + 3, y: vectorY.endPoint.y + 5))
        }
        
        xAxis.step = (xAxis.maxValue - xAxis.minValue) / Double(xAxis.partNumber - 1)
        yAxis.step = (yAxis.maxValue - yAxis.minValue) / Double(yAxis.partNumber - 1)
        
        if xAxis.showAxis {
            showXLables()
        }
        if yAxis.showAxis {
            showYLables()
        }
        
        context?.drawPath(using: .stroke)
        
        for chartData in chartDatas {
            for i in 0...(chartData.itemCount - 1) {
                if ( xAxis.minValue.isLessThanOrEqualTo(chartData.itemXs[i]) && chartData.itemXs[i].isLessThanOrEqualTo(xAxis.maxValue) ) || ( yAxis.minValue.isLessThanOrEqualTo(chartData.itemYs[i])  && chartData.itemYs[i].isLessThanOrEqualTo(yAxis.maxValue) ) {
                    let xFinilizeValue = mappingIsForAxis(isForAxisX: true, value: chartData.itemXs[i])
                    let yFinilizeValue = mappingIsForAxis(isForAxisX: false, value: chartData.itemYs[i])
                    
                    pathLayer = drawingPointsForChartData(charaData: chartData, x: xFinilizeValue, y: yFinilizeValue)
                    layer.addSublayer(self.pathLayer)
                    
                    addAnimationIfNeeded()
                }
            }
        }
    }
    
}
