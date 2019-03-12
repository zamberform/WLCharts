//
//  TableViewController.swift
//  WLCharts_Example
//
//  Created by 王純 on 2019/03/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController : UIViewController = segue.destination
        
        if segue.identifier == "LineChart" {
            viewController.title = "WLLineChart"
        }
        if segue.identifier == "CircleChart" {
            viewController.title = "WLCircularChart"
        }
        else if segue.identifier == "PieChart" {
            viewController.title = "WLPieChart"
        }
        else if segue.identifier == "ScatterChart" {
            viewController.title = "WLScatterChart"
        }
        else if segue.identifier == "RadarChart" {
            viewController.title = "WLRadarChart"
        }
    }
    
}
