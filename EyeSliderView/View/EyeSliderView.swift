//
//  EyeSliderView.swift
//  EyeSliderView
//
//  Created by Furkan Kaynar on 25.05.2019.
//  Copyright © 2019 furrki. All rights reserved.
//

import UIKit

class EyeSliderView: UIView {
    
    open var value: Int {
        return Int((maximumValue - minimumValue) * ratio - minimumValue)
    }
    
    @IBInspectable open var ratio: Float = 0.5 // value of the default slider
    @IBInspectable open var lineWidth: CGFloat = 3.0
    @IBInspectable open var minimumValue: Float = 0.0
    @IBInspectable open var maximumValue: Float = 100.0
    @IBInspectable var circleOffset: CGFloat = 50.0
    @IBInspectable open var minimumTintColor: UIColor = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
    @IBInspectable open var maximumTintColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1)
    @IBInspectable open var circleColor: UIColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
    open var thumbRadius: CGFloat = 10.0
    
    var delegate: EyeSliderDelegate?
    
    var circleCenterX: CGFloat {
        return bounds.size.width * CGFloat(ratio)
    }
    
    var circleCenterY: CGFloat {
        return bounds.size.height * 0.3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = UIColor.white.cgColor
        backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragDrop(gesture:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnSlider(gesture:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapOnSlider(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if location.x > 0 && location.x < frame.width  {
            let newValue = ((location.x ) / (frame.width))
            self.ratio = Float(newValue)
            self.setNeedsDisplay()
            delegate?.eyeSlider(self, didValueChange: self.ratio)
        }
    }
    
    @objc func dragDrop(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        if gesture.state == .changed || gesture.state == .ended {
            if location.x > 0 && location.x < frame.width  {
                let newValue = ((location.x) / (frame.width))
                self.ratio = Float(newValue)
                self.setNeedsDisplay()
                delegate?.eyeSlider(self, didValueChange: self.ratio)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        setupMask(rect)
    }
    
    var circleShape: CAShapeLayer?
    var minimumLineShape: CAShapeLayer?
    var maximumLineShape: CAShapeLayer?
    
    internal func setupMask(_ rect: CGRect) {
        circleShape?.removeFromSuperlayer()
        minimumLineShape?.removeFromSuperlayer()
        maximumLineShape?.removeFromSuperlayer()
        circleShape = {
            let x = circleCenterX
            let y = circleCenterY
            
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: x, y: y),
                radius: thumbRadius,
                startAngle: CGFloat(0),
                endAngle: .pi * 2,
                clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            shapeLayer.fillColor = circleColor.cgColor
            shapeLayer.strokeColor = circleColor.cgColor
            shapeLayer.lineWidth = 1
            return shapeLayer
        }()
        
        minimumLineShape = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: circleCenterY))
            
            path.addLine(to: CGPoint(x: circleCenterX - circleOffset, y: circleCenterY))
            
            path.addCurve(to: CGPoint(x: circleCenterX, y: circleCenterY - circleOffset / 2),
                          controlPoint1: CGPoint(x: circleCenterX - circleOffset / 3, y: circleCenterY),
                          controlPoint2: CGPoint(x: circleCenterX - circleOffset / 2, y: circleCenterY - circleOffset / 2))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = lineWidth
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = minimumTintColor.cgColor
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            return shapeLayer
        }()
        
        maximumLineShape = {
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: circleCenterX , y: circleCenterY + circleOffset / 2))
            //            path.addQuadCurve(to: CGPoint(x: circleCenterX, y: circleCenterY + circleOffset / 2), controlPoint: CGPoint(x: circleCenterX + circleOffset, y: circleCenterY + circleOffset))
            
            
            path.addCurve(to: CGPoint(x: circleCenterX + circleOffset, y: circleCenterY),
                          controlPoint1: CGPoint(x: circleCenterX + circleOffset / 2, y: circleCenterY + circleOffset / 2),
                          controlPoint2: CGPoint(x: circleCenterX + circleOffset / 3, y: circleCenterY))
            
            //            path.addQuadCurve(to: CGPoint(x: circleCenterX + circleOffset / 2, y: circleCenterY), controlPoint: CGPoint(x: circleCenterX + circleOffset / 2, y: circleCenterY))
            
            path.addLine(to: CGPoint(x: bounds.width , y: circleCenterY))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = lineWidth
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = maximumTintColor.cgColor
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            return shapeLayer
        }()
        
        layer.addSublayer(circleShape!)
        
        if circleCenterX >= circleOffset * 0.9 {
            layer.addSublayer(minimumLineShape!)
        }
        
        if circleCenterX <= frame.width - circleOffset * 0.9 {
            layer.addSublayer(maximumLineShape!)
        }
    }
}

protocol EyeSliderDelegate {
    func eyeSlider(_ eyeSliderView: EyeSliderView, didValueChange value: Float)
}
