//
//  LineChartViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WLCharts

class LineChartViewController: UIViewController {
    @IBOutlet weak var test: WLLineChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data: [Double] = [13, 22, 28, 83, 65]
        let xLabels: [String] = ["1時", "2時", "3時", "4時", "5時", "6時", "7時"]
        test.animation.enabled = true
        test.area = true
        test.curved = false
        test.x.labels.visible = true
        test.x.grid.count = 7
        test.y.grid.count = 25
        test.x.axis.margin = 50
        test.y.axis.margin = 80
        test.x.labels.values = xLabels
        test.y.labels.visible = true
        test.chartColors = [WLLineColor(lineColor: .green, areaColor: .green, dotColor: .red)]
        test.y.end = 100
        test.y.start = 0
        test.y.unitCall = "カロリー"
        test.addLine(data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
