//
//  WLScatterFont.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/11.
//

public struct WLScatterFont {
    public var showLabel: Bool = true
    public var descriptionTextFont: UIFont = UIFont(name: "Avenir-Medium", size: 9.0)!
    var descriptionTextColor: UIColor = UIColor.black
    
    public var descriptionTextShadowColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    public var descriptionTextShadowOffset: CGSize = CGSize(width: 0, height: 1)
}
