//
//  WLLineCharts.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/05.
//

import UIKit
import QuartzCore

open class WLLineChart: UIView {
    
    // settings about linechart
    public var area: Bool = true
    public var curved: Bool = true
    public var lineWidth: Double = 2
    public var selected: Int = -1
    
    public var x: WLLineX = WLLineX()
    public var y: WLLineY = WLLineY()
    
    public var dots: WLLineDots = WLLineDots()
    public var animation: WLLineAnimation = WLLineAnimation()
    public var chartColors: [WLLineColor] = []
    
    open var delegate: WLLineChartDelegate?
    
    fileprivate var dataStoreHouse: [[Double]] = []
    fileprivate var colorStoreHouse: [UIColor] = []
    fileprivate var dataPoints: [CGPoint] = []
    fileprivate var dotsStoreHourse: [[WLLineDot]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    fileprivate var xStep: Double = 0
    fileprivate var yStep: Double = 0
    
    fileprivate var removeAll: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            return
        }
        
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        for dots in dotsStoreHourse {
            for dot in dots {
                dot.removeFromSuperlayer()
            }
        }
        dotsStoreHourse.removeAll()
        
        if dataStoreHouse.count <= 0 {
            return
        }
        
        if x.grid.visible && y.grid.visible { drawGrid() }
        if x.axis.visible && y.axis.visible { drawAxes() }
        
        if x.labels.visible { drawXLabels() }
        if y.labels.visible { drawYLabels() }
        
        for (lineIndex, _) in dataStoreHouse.enumerated() {
            drawLine(lineIndex)
            
            if dots.visible { drawDataDots(lineIndex) }
            if area { drawAreaBeneathLineChart(lineIndex) }
        }
    }
    
    fileprivate func getYValuesForXValue(_ x: Int) -> [Double] {
        var result: [Double] = []
        for lineData in dataStoreHouse {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    fileprivate func handleTouchEvents(_ touches: NSSet!, event: UIEvent) {
        if (self.dataStoreHouse.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject() as AnyObject
        let xValue = point.location(in: self).x
        let inverted = Double(xValue) / xStep
        let rounded = Int(round(inverted)) - 1
        let yValues: [Double] = getYValuesForXValue(rounded)
        let selectPos = highlightDataPoints(rounded)
        delegate?.didSelectDotData(rounded, yValues: yValues)
        if selectPos != CGPoint.zero {
            delegate?.didSelectDotPoint(selectPos)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet, event: event!)
    }
    
    fileprivate func highlightDataPoints(_ index: Int) -> CGPoint {
        for (lineIndex, dotsData) in dotsStoreHourse.enumerated() {
            for dot in dotsData {
                dot.backgroundColor = chartColors[lineIndex].dotColor.cgColor
            }
            var dot: WLLineDot
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index - 1]
            }
            
            dot.backgroundColor = WLLineColorHelper.lightenUIColor(chartColors[lineIndex].dotColor).cgColor
            
            return dot.position
        }
        
        return CGPoint.zero
    }
    
    fileprivate func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [WLLineDot] = []
        var data = dataStoreHouse[lineIndex]
        
        for index in 0..<data.count {
            let xValue = Double(index) * xStep + y.axis.margin - dots.outerRadius/2
            let yValue = Double(self.bounds.height) - Double((data[index] - y.start) / y.grid.count) * yStep - x.axis.margin - dots.outerRadius/2
            
            let dotLayer = WLLineDot()
            dotLayer.dotInnerColor = chartColors[lineIndex].dotColor
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = chartColors[lineIndex].dotColor.cgColor
            dotLayer.cornerRadius = CGFloat(dots.outerRadius / 2)
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
            
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                dotLayer.add(anim, forKey: "opacity")
            }
            
            if index == selected {
                dotLayer.backgroundColor = WLLineColorHelper.lightenUIColor(chartColors[lineIndex].dotColor).cgColor
            }
            else if index == data.count - 1 {
                dotLayer.backgroundColor = chartColors[lineIndex].dotColor.cgColor
            }
        }
        
        dotsStoreHourse.append(dotLayers)
    }
    
    fileprivate func drawAxes() {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        
        x.axis.color.setStroke()
        let y0 = Double(height) - x.axis.margin
        path.move(to: CGPoint(x: y.axis.margin, y: y0))
        path.addLine(to: CGPoint(x: Double(width), y: y0))
        path.stroke()
        
        y.axis.color.setStroke()
        path.move(to: CGPoint(x: y.axis.margin, y: Double(height) - x.axis.margin))
        path.addLine(to: CGPoint(x: y.axis.margin, y: 0))
        path.stroke()
    }
    
    fileprivate func drawLine(_ lineIndex: Int) {
        
        var data = dataStoreHouse[lineIndex]
        
        for index in 0..<data.count {
            let xValue = Double(index) * xStep + y.axis.margin
            let yValue = Double(self.bounds.height) - Double((data[index] - y.start) / y.grid.count) * yStep - x.axis.margin
            dataPoints.append(CGPoint(x: xValue, y: yValue))
        }
        if let path = WLLineAlgorithm.shared.createPath(dataPoints, curved: curved) {
            let layer = CAShapeLayer()
            layer.frame = self.bounds
            layer.path = path.cgPath
            layer.strokeColor = chartColors[lineIndex].lineColor.cgColor
            layer.fillColor = nil
            layer.lineWidth = CGFloat(lineWidth)
            self.layer.addSublayer(layer)
            
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "strokeEnd")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                layer.add(anim, forKey: "strokeEnd")
            }
            
            lineLayerStore.append(layer)
            
        }
    }
    
    fileprivate func drawAreaBeneathLineChart(_ lineIndex: Int) {
        var data = self.dataStoreHouse[lineIndex]
        let outpath = UIBezierPath()
        
        chartColors[lineIndex].areaColor.withAlphaComponent(0.2).setFill()
        outpath.move(to: CGPoint(x: y.axis.margin, y: Double(self.bounds.height) - x.axis.margin))
        outpath.addLine(to: CGPoint(x: y.axis.margin, y: Double(self.bounds.height) - Double((data[0] - y.start) / y.grid.count) * yStep - x.axis.margin))
        if let path = WLLineAlgorithm.shared.createArea(path: outpath, dataPoints: dataPoints, curved: curved) {
            path.addLine(to: CGPoint(x: Double(data.count - 1) * xStep + y.axis.margin, y: Double(self.bounds.height) - x.axis.margin))
            path.addLine(to: CGPoint(x: y.axis.margin, y: Double(self.bounds.height) - x.axis.margin))
            path.fill()
        }
        
    }
    
    fileprivate func drawXGrid() {
        x.grid.color.setStroke()
        let path = UIBezierPath()
        var x1: Double
        let y1 = Double(self.bounds.height) - x.axis.margin
        xStep = (Double(self.bounds.width) - y.axis.margin) / x.grid.count
        for i in stride(from: 0, through: x.grid.count, by: 1){
            x1 = xStep * i + y.axis.margin
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x1, y: 0))
        }
        path.stroke()
    }
    
    fileprivate func drawYGrid() {
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: Double = y.axis.margin
        let x2: Double = Double(self.bounds.width)
        let numStep = (y.end - y.start) / y.grid.count
        yStep = (Double(self.bounds.height) - x.axis.margin) / numStep
        var y1: Double
        for i in stride(from: y.start, through: y.end, by: y.grid.count){
            y1 = Double(self.bounds.height) - yStep * Double(Int(i / y.grid.count)) - x.axis.margin
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }
    
    fileprivate func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    fileprivate func drawXLabels() {
        let xAxisData = x.labels.values
        let maxWidth = Double((xAxisData.max(by: {$1.count > $0.count})?.count)!)
        let posY = Double(self.bounds.height) - x.axis.margin
        let width = maxWidth * x.labels.fontSize
        var text: String
        for (index, _) in xAxisData.enumerated() {
            let xValue = xStep * Double(index) + y.axis.margin
            let label = UILabel(frame: CGRect(x: xValue - width / 2, y: posY, width: width, height: x.axis.margin))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .center
            if (x.labels.values.count != 0) {
                text = x.labels.values[index]
            } else {
                text = String(index)
            }
            label.text = text
            self.addSubview(label)
        }
    }
    
    fileprivate func drawYLabels() {
        var labelWidth = Double(String(y.end).count) * y.labels.fontSize
        if y.unitCall.count != 0 {
            labelWidth = labelWidth + Double(y.unitCall.count) * y.labels.fontSize
        }
        for i in stride(from: y.start, through: y.end, by: y.grid.count){
            let index = i / y.grid.count
            
            if Int(index) == 0 {
                continue
            }
            
            let label = UILabel(frame: CGRect(x:-y.labels.fontSize, y: Double(self.bounds.height) - index * yStep - x.axis.margin - y.labels.fontSize / 2, width: y.axis.margin, height: y.labels.fontSize))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .right
            label.text = String(Int(round(i))) + y.unitCall
            self.addSubview(label)
        }
    }
    
    open func addLine(_ data: [Double]) {
        dataStoreHouse.append(data)
        self.setNeedsDisplay()
    }
    
    open func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    open func clear() {
        dataStoreHouse.removeAll()
        self.setNeedsDisplay()
    }
    
    open func addSelectStamp() {
        
    }
}

