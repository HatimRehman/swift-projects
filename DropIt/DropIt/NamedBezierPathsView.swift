//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by Hatim Rehman on 2016-07-09.
//  Copyright © 2016 Hatim. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {
    
    var bezierPaths = [String: UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }

}
