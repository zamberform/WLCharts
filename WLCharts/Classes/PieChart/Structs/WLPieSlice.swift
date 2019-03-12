//
//  WLSlice.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/06.
//

public struct WLPieSlice {
    public var color: UIColor!
    public var value: Double!
    public var tag: String?
    
    public init(color: UIColor, value: Double, tag: String) {
        self.color = color
        self.value = value
        self.tag = tag
    }
}
