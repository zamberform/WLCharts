//
//  PieChartViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//
import UIKit
import WLCharts

class PieChartViewController: UIViewController {
    @IBOutlet weak var test: WLPiechart!
    override func viewDidLoad() {
        super.viewDidLoad()
        let error = WLPieSlice(color: .magenta, value: 4, tag: "Error")
        
        let zero = WLPieSlice(color: .blue, value: 6, tag: "Zero")
        
        let win = WLPieSlice(color: .orange, value: 10, tag: "Winner")
        
        test.slices = [error, zero, win]
        test.donutsPercent = 0.3
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
