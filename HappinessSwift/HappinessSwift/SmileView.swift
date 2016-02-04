//
//  SmileView.swift
//  HappinessSwift
//
//  Created by ZhangBingPC on 15/7/15.
//  Copyright (c) 2015年 ZhangBing. All rights reserved.
//

import UIKit

//make protocal
protocol FaceViewDataSource: class{
    func smilenessForFaceVIew(sender: SmileView) -> Double?
}

@IBDesignable
class SmileView: UIView {

    @IBInspectable
    var lineWidth: CGFloat = 3 {didSet{setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.redColor() {didSet {setNeedsDisplay()}}
    @IBInspectable
    var faceScale: CGFloat = 0.9 {
        didSet{
        setNeedsDisplay()
        }
    }
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.width,bounds.size.height)/2 * faceScale
    }

    //property
    weak var dataSource: FaceViewDataSource?

    func scale(gesture:UIPanGestureRecognizer) {
        
    }

//constants
    private struct Scaling {
        static let FaceRadiusToEyesRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRation: CGFloat = 1.5
        static let FaceRadiusToMouthWithRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }

    //eyes
    private enum Eye {case Left,Right}
    private func bezierPathForEyes(whichEye:Eye) -> UIBezierPath {
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyesRatio
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeperation = faceRadius/Scaling.FaceRadiusToEyeSeparationRation

        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left:eyeCenter.x-=eyeHorizontalSeperation/2
        case .Right: eyeCenter.x+=eyeHorizontalSeperation/2
        }

        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        path.lineWidth = lineWidth

        return path
    }

    //mouth
    private func bezierPathForMouth(fractionOfMaxSmile: CGFloat) -> UIBezierPath {

        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWithRatio
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRatio
        //-1~1
        let smileHeight = max(min(fractionOfMaxSmile, 1), 1)*mouthHeight

        let start = CGPointMake(faceCenter.x-mouthWidth/2, faceCenter.y+mouthVerticalOffset)
        let end = CGPointMake(start.x+mouthWidth, start.y)

        let cp1 = CGPointMake(start.x+(mouthWidth/3), start.y+(smileHeight))
        let cp2 = CGPointMake(end.x-(mouthWidth/3), cp1.y)

        let path = UIBezierPath()
        path.moveToPoint(cp1)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth

        let color = UIColor.orangeColor()
        color.set()

        return path
    }

    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter:faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)

        facePath.lineWidth = lineWidth
        color.set()//set color
        facePath.stroke()

        bezierPathForEyes(Eye.Left).stroke()
        bezierPathForEyes(.Right).stroke()

        let smileness = dataSource?.smilenessForFaceVIew(self) ?? 0.0
        let smilePath = bezierPathForMouth(0)
        smilePath.stroke()
    }

}
