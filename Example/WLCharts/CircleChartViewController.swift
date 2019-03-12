//
//  CircleChartViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WLCharts

class CircleChartViewController: UIViewController {
    @IBOutlet weak var test: WLCircularChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        test.displayProgress = 0.7
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
