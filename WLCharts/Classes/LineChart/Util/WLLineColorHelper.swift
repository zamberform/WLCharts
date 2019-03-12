//
//  ColorHelper.swift
//  FBSnapshotTestCase
//
//  Created by 王純 on 2019/03/05.
//
public class WLLineColorHelper {
    public class func lightenUIColor(_ color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 2, alpha: a)
    }
}
