//
//  ProgressCircleView.swift
//  ProgressCircleView
//
//  Created by Luis  Costa on 12/02/18.
//  Copyright © 2018 Luis  Costa. All rights reserved.
//

import UIKit

@IBDesignable
@available(iOS 8.2, *)
public class ProgressCircleView: UIView {
    
    public enum LabelTypeAnimation {
        case linear
        case easeIn
        case easeOut
    }
    
    public enum LabelCounterType {
        case int
        case float
    }
    
    fileprivate var _startPercentage: CGFloat = 0
    fileprivate var _endPercentage: CGFloat = 75
    fileprivate var _radius: CGFloat!
    fileprivate var _clockwise: Bool = true
    fileprivate var _label: CountingLabel = CountingLabel()
    fileprivate var _strokeColor: UIColor = UIColor.green
    fileprivate var _backgroundStrokeColor: UIColor = UIColor.lightGray
    fileprivate var _strokeLineWidth: CGFloat = 20
    fileprivate var _labelSize: CGSize = CGSize(width: 200, height: 200)
    fileprivate var _labelFont: UIFont = UIFont.systemFont(ofSize: 80, weight: .medium)
    
    // Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Open Properties
    open var labelFont: UIFont {
        set {
            _label.font = newValue
        }
        get { return _label.font }
    }
    
    open var labelSize: CGSize {
        set {
            let frame = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
            _label.frame = frame
            _label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.layoutIfNeeded()
        }
        get { return _label.frame.size }
    }
    
    
    @IBInspectable
    open var startPercentage: CGFloat {
        set { _startPercentage = newValue }
        get { return _startPercentage }
    }
    
    @IBInspectable
    open var endPercentage: CGFloat {
        set { _endPercentage = newValue }
        get { return _endPercentage }
    }
    
    // TODO: Only available clockwise
    //    @IBInspectable
    //    open var clockwise: Bool {
    //        set { _clockwise = clockwise }
    //        get { return _clockwise }
    //    }
    
    @IBInspectable
    open var radius: CGFloat {
        set { _radius = newValue }
        get { return _radius }
    }
    
    @IBInspectable
    open var strokeColor: UIColor {
        set {
            _label.textColor = newValue
            _strokeColor = newValue
        }
        get { return _strokeColor }
    }
    
    @IBInspectable
    open var backgroundStrokeColor: UIColor {
        set { _backgroundStrokeColor = newValue }
        get { return _backgroundStrokeColor }
    }
    
    @IBInspectable
    open var labelText: String? {
        set { _label.text = newValue}
        get { return _label.text }
    }
    
    @IBInspectable
    open var labelTextAlignment: NSTextAlignment {
        set { _label.textAlignment = newValue  }
        get { return _label.textAlignment }
    }
    
    @IBInspectable
    open var labelTextColor: UIColor {
        set { _label.textColor = newValue }
        get { return _label.textColor }
    }
    
    @IBInspectable
    open var lineWidthStroke: CGFloat {
        set { _strokeLineWidth = newValue }
        get { return _strokeLineWidth }
    }
}

// MARK: - Private Functions
@available(iOS 8.2, *)
extension ProgressCircleView {
    
    fileprivate func setupView() {
        self._radius = frame.width/2
        self._label.textAlignment = .center
        self._label.textColor = strokeColor
        self._label.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        self._label.textColor = strokeColor
        self._label.center = self.center
        self.addSubview(_label)
    }
}

// MARK: - Private Functions
@available(iOS 8.2, *)
extension ProgressCircleView {
    public func animate(duration: CFTimeInterval, animated: Bool, animationType: LabelTypeAnimation, counter: LabelCounterType) {
        
        let centerView = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        // BackEndPath
        let backgroundPath = UIBezierPath(arcCenter: centerView, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = backgroundStrokeColor.cgColor
        backgroundLayer.lineWidth = lineWidthStroke
        backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
        
        let startAngleRadians = startPercentage * 2 * CGFloat.pi / 100 - (CGFloat.pi / 2)
        
        let endAngleRadians = endPercentage * 2 * CGFloat.pi / 100 - (CGFloat.pi / 2)
        
        // Circular Path
        let circularPath = UIBezierPath(arcCenter: centerView, radius: radius, startAngle: startAngleRadians, endAngle: endAngleRadians, clockwise: true)
        
        // Contour Layer
        let contourLayer = CAShapeLayer()
        contourLayer.path = circularPath.cgPath
        contourLayer.strokeColor = strokeColor.cgColor
        contourLayer.lineWidth = lineWidthStroke
        contourLayer.fillColor = UIColor.clear.cgColor
        contourLayer.strokeEnd = animated ? 0 : 1
        self.layer.addSublayer(contourLayer)
        
        if animated {
            // Animations
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.toValue = 1
            strokeAnimation.duration = duration
            strokeAnimation.fillMode = kCAFillModeForwards
            strokeAnimation.isRemovedOnCompletion = false
            contourLayer.lineCap = kCALineCapRound
            contourLayer.add(strokeAnimation, forKey: "strokeAnimation")
            
            var animationTypeLabel: CountingLabel.CounterAnimationType!
            switch animationType {
            case .easeIn:
                animationTypeLabel = .easeIn
                break
                
            case .easeOut:
                animationTypeLabel = .easeOut
                break
                
            case .linear:
                animationTypeLabel = .linear
                break
            }
            
            var counterLabel: CountingLabel.CounterType
            switch counter {
            case .float:
                counterLabel = .float
                break
                
            case .int:
                counterLabel = .int
                break
            }
            
            _label.count(fromValue: Float(startPercentage), to: Float(endPercentage) - Float(startPercentage), withDuration: duration, animationType: animationTypeLabel, counterType: counterLabel)
        } else {
            _label.text = "\(Int(endPercentage - startPercentage))%"
        }
    }
    
}

