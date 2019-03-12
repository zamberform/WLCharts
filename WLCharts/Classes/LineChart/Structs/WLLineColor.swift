//
//  WLColor.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/06.
//

public struct WLLineColor {
    public var lineColor: UIColor = .white
    public var areaColor: UIColor = .white
    public var dotColor: UIColor = .white
    
    public init(lineColor: UIColor, areaColor: UIColor, dotColor: UIColor) {
        self.lineColor = lineColor
        self.areaColor = areaColor
        self.dotColor = dotColor
    }
}
