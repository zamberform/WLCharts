//
//  WLScatterAxis.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/11.
//

public struct WLScatterAxis {
    public var color: UIColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    var width: Double = 1.0
    var labelFormat: String = ""
    public var minValue: Double = 0
    public var maxValue: Double = 0
    public var margin: Double = 30
    public var showAxis: Bool = true
    public var partNumber: Int = 0
    var step: Double = 0
    public var labels: [String] = []
    var showLabel: Bool = true
}
