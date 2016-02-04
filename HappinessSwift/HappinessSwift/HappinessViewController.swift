//
//  HappinessViewController.swift
//  HappinessSwift
//
//  Created by ZhangBingPC on 15/7/15.
//  Copyright (c) 2015年 ZhangBing. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    @IBOutlet var faceView: SmileView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: faceView, action: self))
        }
    }
//model
    var happiness:Int = 100{
        didSet{
            happiness = min(max(happiness, 0),100)
            self.updateUI()
        }
    }

    func updateUI() {
        faceView.setNeedsDisplay()
    }
    func smilenessForFaceVIew(sender: SmileView) -> Double? {
        return Double(happiness-50)/50
    }

}
