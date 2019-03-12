//
//  WLDot.swift
//  wlcharts
//
//  Created by 王純 on 2019/03/05.
//  Copyright © 2019 Sakiki. All rights reserved.
//

import UIKit

class WLLineDot: CALayer {
    
    var innerRadius: Double = 8
    var dotInnerColor = UIColor.white
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - CGFloat(innerRadius)
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: inset/2, dy: inset/2)
        innerDotLayer.backgroundColor = UIColor.white.cgColor
        innerDotLayer.cornerRadius = CGFloat(innerRadius / 2)
        self.addSublayer(innerDotLayer)
    }
    
}
