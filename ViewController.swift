//
//  ViewController.swift
//  Canvas
//
//  Created by ZengJintao on 3/3/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var newlyCreatedFace: UIImageView!
    var faceOriginalCenter: CGPoint!
    
    
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trayOriginalCenter = self.trayView.center

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onCustomPinch:")
        pinchGestureRecognizer.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = sender.locationInView(view)
        
        // Total translation (x,y) over time in parent view's coordinate system
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            self.trayCenterWhenOpen = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y)
            self.trayCenterWhenClosed = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + 185)
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
//            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            if velocity.y < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        self.trayView.center = self.trayCenterWhenOpen
                    }, completion: { (success:Bool) -> Void in
                        
                })
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenClosed
                    }, completion: { (success:Bool) -> Void in
                        
                })

            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    @IBAction func dragFace(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            
            newlyCreatedFace.center = point
            faceOriginalCenter = point
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.userInteractionEnabled = true
        } else if sender.state == UIGestureRecognizerState.Changed {
//            print("Gesture changed at: \(point)")
            var center = faceOriginalCenter
            center!.x += translation.x
            center!.y += translation.y
            
            newlyCreatedFace.center = center!
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        var point = panGestureRecognizer.locationInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            faceOriginalCenter = panGestureRecognizer.view?.center

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            var center = faceOriginalCenter
            center.x += translation.x
            center.y += translation.y
            
            panGestureRecognizer.view!.center = center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            if point.y > 344 {
                panGestureRecognizer.view!.center = faceOriginalCenter
            }
        }
    }
    
    func onCustomPinch(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        print("in pinch")
        let scale = pinchGestureRecognizer.scale
        pinchGestureRecognizer.view!.transform = CGAffineTransformMakeScale(scale, scale)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

