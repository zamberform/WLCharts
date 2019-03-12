//
//  WLLineChartProtocols.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/05.
//

public protocol WLLineChartDelegate {
    func didSelectDotData(_ x: Int, yValues: [Double])
    func didSelectDotPoint(_ pos: CGPoint)
}

