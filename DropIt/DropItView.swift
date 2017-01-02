//
//  DropItView.swift
//  DropIt
//
//  Created by Hatim Rehman on 2016-07-09.
//  Copyright © 2016 Hatim. All rights reserved.
//

import UIKit
import CoreMotion

class DropItView: NamedBezierPathsView, UIDynamicAnimatorDelegate {
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        //removeCompletedRow()
    }
    
    private let dropBehavior = FallingObjectBehavior()
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
                updateRealGravity()
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    var realGravity: Bool = false {
        didSet {
            updateRealGravity()
        }
    }
    
    private let motionManager = CMMotionManager()
    
    private func updateRealGravity() {
        if realGravity {
            if motionManager.accelerometerAvailable && !motionManager.accelerometerActive {
                motionManager.accelerometerUpdateInterval = 0.25 // 4 times a second
                motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
                { [unowned self] (data, error) in
                    if self.dropBehavior.dynamicAnimator != nil {
                        if var dx = data?.acceleration.x, var dy = data?.acceleration.y {
                            switch UIDevice.currentDevice().orientation {
                            case .Portrait: dy = -dy
                            case .PortraitUpsideDown: break
                            case .LandscapeRight: swap(&dx, &dy)
                            case .LandscapeLeft: swap(&dx, &dy); dy = -dy
                            default: dx = 0; dy = 0
                            }
                            self.dropBehavior.gravity.gravityDirection = CGVector(dx: dx, dy: dy)
                        }
                        
                    } else {
                        self.motionManager.stopAccelerometerUpdates()
                    }
                }
            }
         else {
            motionManager.stopAccelerometerUpdates()
            }
        }
    }
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment!.action = {
                    if let attachedDrop = self.attachment!.items.first as? UIView {
                        //self.bezierPaths = UIBezierPath.lineFrom
                    }
                }
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //dropBehavior.addBarrier(path, named: "Middle Barrier")
        //bezierPaths["Middle Barrier"] = path
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer){
        let gesturePoint = recognizer.locationInView(self)
        switch recognizer.state {
        case .Began:
            // create the attachment
            if let dropToAttachTo = lastDrop where dropToAttachTo.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .Changed:
            // change the attachment's anchor point
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }
    
    private let dropsPerRow = 10
    
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    private var lastDrop: UIView?
    
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat(arc4random() % UInt32(dropsPerRow)) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.blueColor()
        
        addSubview(drop)
        dropBehavior.addItem(drop)
        lastDrop = drop
    }
}
