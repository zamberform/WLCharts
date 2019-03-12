//
//  ScatterChartViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WLCharts

class ScatterChartViewController: UIViewController {
    @IBOutlet weak var test: WLScatterChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.xAxis.minValue = 20
        test.xAxis.maxValue = 100
        test.xAxis.partNumber = 6
        test.xAxis.labels = ["x1", "x2", "x3", "x4", "x5", "x6"]
        test.yAxis.minValue = 30
        test.yAxis.maxValue = 50
        test.yAxis.partNumber = 5
        test.yAxis.labels = ["y1", "y2", "y3", "y4", "y5"]
        
        var testData = randomSetOfObjects()
        var testScatterData = WLScatterValue()
        testScatterData.strokeColor = .green
        testScatterData.fillColor = .blue
        testScatterData.size = 2
        testScatterData.itemCount = testData[0].count
        
        testScatterData.itemXs = testData[0]
        testScatterData.itemYs = testData[1]
        
        test.setScatterDatas([testScatterData])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func randomSetOfObjects() -> [[Double]] {
        var xArray: [Double] = []
        var yArray: [Double] = []
        
        for _ in 0...24 {
            xArray.append(getRandomNumber(min: test.xAxis.minValue, max: test.xAxis.maxValue))
            yArray.append(getRandomNumber(min: test.yAxis.minValue, max: test.yAxis.maxValue))
        }
        
        return [xArray, yArray]
    }
    
    private func getRandomNumber(min: Double, max: Double)->Double {
        
        return Double(arc4random_uniform(UINT32_MAX)) / Double(UINT32_MAX ) * (max - min) + min
    }
}
