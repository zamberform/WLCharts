//
//  RadarChartViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WLCharts

class RadarChartViewController: UIViewController {
    @IBOutlet weak var test: WLRadarChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = [WLRadarValue(value: 3, text: "TOYOTA"),
                     WLRadarValue(value: 2, text: "NISSAN"),
                     WLRadarValue(value: 8, text: "VOLVO"),
                     WLRadarValue(value: 5, text: "SUBARU"),
                     WLRadarValue(value: 4, text: "Other")]
        
        test.addRadarDatas(items)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

