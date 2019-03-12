//
//  WLCurveAlgorithm.swift
//  wlcharts
//
//  Created by 王純 on 2019/03/05.
//  Copyright © 2019 Sakiki. All rights reserved.
//
import UIKit

struct StampLineChartCurvedSegment {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}

class WLLineAlgorithm {
    static let shared = WLLineAlgorithm()
    
    private func controlPointsFrom(points: [CGPoint]) -> [StampLineChartCurvedSegment] {
        var result: [StampLineChartCurvedSegment] = []
        
        let delta: CGFloat = 0.3
        
        for i in 1..<points.count {
            let A = points[i-1]
            let B = points[i]
            let controlPoint1 = CGPoint(x: A.x + delta*(B.x-A.x), y: A.y + delta*(B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta*(B.x-A.x), y: B.y - delta*(B.y - A.y))
            let curvedSegment = StampLineChartCurvedSegment(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }
        
        if points.count <= 1 {
            return result
        }
        for i in 1..<points.count-1 {
            let M = result[i-1].controlPoint2
            
            let N = result[i].controlPoint1
            
            let A = points[i]
            
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)
            
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)
            
            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x)/2, y: (MM.y + N.y)/2)
            result[i-1].controlPoint2 = CGPoint(x: (NN.x + M.x)/2, y: (NN.y + M.y)/2)
        }
        
        return result
    }
    
    func createPath(_ dataPoints: [CGPoint], curved: Bool) -> UIBezierPath? {
        if dataPoints.count <= 0 {
            return nil
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        
        var curveSegments: [StampLineChartCurvedSegment] = []
        curveSegments = controlPointsFrom(points: dataPoints)
        
        for i in 1..<dataPoints.count {
            if curved {
                path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
            }
            else {
                path.addLine(to: dataPoints[i])
            }
        }
        return path
    }
    
    func createArea(path: UIBezierPath, dataPoints: [CGPoint], curved: Bool) -> UIBezierPath? {
        
        var curveSegments: [StampLineChartCurvedSegment] = []
        curveSegments = controlPointsFrom(points: dataPoints)
        
        for i in 1..<dataPoints.count {
            if curved {
                path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
            }
            else {
                path.addLine(to: dataPoints[i])
            }
        }
        return path
    }
}
