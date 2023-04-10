//
//  ShieldButton.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

class ShieldButton: UIView {
    
    // MARK: - Fields
    public var pressAction: ((Int) -> Void)?
    public var touchesBeganAction: ((Int) -> CGColor)?
    var pathNorth = UIBezierPath()
    var pathNorthEast = UIBezierPath()
    var pathEast = UIBezierPath()
    var pathSouthEast = UIBezierPath()
    var pathSouth = UIBezierPath()
    var pathSouthWest = UIBezierPath()
    var pathWest = UIBezierPath()
    var pathNorthWest = UIBezierPath()
    var angle = CGFloat(11 * CGFloat.pi / 8.0)
    let angleIncrement = CGFloat(CGFloat.pi / 4.0)
    var position = CGPoint()
    var pathList = [UIBezierPath]()
    var layerList = [CAShapeLayer]()
    private let frontLayerNorth = CAShapeLayer()
    private let frontLayerNorthEast = CAShapeLayer()
    private let frontLayerEast = CAShapeLayer()
    private let frontLayerSouthEast = CAShapeLayer()
    private let frontLayerSouth = CAShapeLayer()
    private let frontLayerSouthWest = CAShapeLayer()
    private let frontLayerWest = CAShapeLayer()
    private let frontLayerNorthWest = CAShapeLayer()
    private let topOutsideLayer = CAShapeLayer()
    private let bottomOutsideLayer = CAShapeLayer()
    private let insideLayer = CAShapeLayer()
    
    // MARK: - LifeCycle
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureUI() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.shieldButtonPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
        pathList = [self.pathNorth, self.pathNorthEast, self.pathEast, self.pathSouthEast, self.pathSouth, self.pathSouthWest, self.pathWest, self.pathNorthWest]
        layerList = [self.frontLayerNorth, self.frontLayerNorthEast, self.frontLayerEast, self.frontLayerSouthEast, self.frontLayerSouth, self.frontLayerSouthWest, self.frontLayerWest, self.frontLayerNorthWest]
        for i in 0..<pathList.count {
            layer.addSublayer(layerList[i])
        }
        layer.addSublayer(topOutsideLayer)
        layer.addSublayer(bottomOutsideLayer)
        layer.addSublayer(insideLayer)
    }
    
    func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        let x = radius * cos(angle) + offset.x
        let y = radius * sin(angle) + offset.y

        return CGPoint(x: x, y: y)
    }
    
    func createShieldPart(path: UIBezierPath, layer: CAShapeLayer) {
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let radius = (frame.width / 2.0) - 20.0
        let midRadius = 0.55 * radius
        let leftLowerPoint = pointFrom(angle: angle, radius: midRadius, offset: center)
        let leftUpperPoint = pointFrom(angle: angle, radius: radius, offset: center)
        let rigthLowerPoint = pointFrom(angle: angle + angleIncrement, radius: midRadius, offset: center)
        path.move(to: leftLowerPoint)
        path.addLine(to: leftUpperPoint)
        path.addArc(withCenter: center, radius: radius, startAngle: angle, endAngle: angle + angleIncrement, clockwise: true)
        path.addLine(to: rigthLowerPoint)
        path.addArc(withCenter: center, radius: midRadius, startAngle: angle + angleIncrement, endAngle: angle, clockwise: false)
        path.close()
        layer.frame = bounds
        layer.path = path.cgPath
        layer.lineWidth = 1
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
    }
    
    func createOutsideLayers(layers: [CAShapeLayer]) {
        var path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let radius = (frame.width / 2.0) - 20.0
        let leftFrameBouncePoint = pointFrom(angle: .pi, radius: frame.width / 2, offset: center)
        let leftBottomBouncePoint = pointFrom(angle: .pi, radius: radius, offset: center)
        let rightFrameBouncePoint = pointFrom(angle: 0, radius: frame.width / 2, offset: center)
        let leftTopAngle = CGPoint(x: 0, y: 0)
        let rigthTopAngle = CGPoint(x: frame.width, y: 0)
        let leftBottomAngle = CGPoint(x: 0, y: frame.height)
        let rigthBottomAngle = CGPoint(x: frame.width, y: frame.height)
        path.move(to: leftFrameBouncePoint)
        path.addLine(to: leftBottomBouncePoint)
        path.addArc(withCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        path.addLine(to: rightFrameBouncePoint)
        path.addLine(to: rigthTopAngle)
        path.addLine(to: leftTopAngle)
        path.addLine(to: leftFrameBouncePoint)
        path.close()
        layers[0].frame = bounds
        layers[0].path = path.cgPath
        layers[0].lineWidth = 0
        layers[0].fillColor = UIColor.black.cgColor
        path = UIBezierPath()
        path.move(to: leftFrameBouncePoint)
        path.addLine(to: leftBottomBouncePoint)
        path.addArc(withCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addLine(to: rightFrameBouncePoint)
        path.addLine(to: rigthBottomAngle)
        path.addLine(to: leftBottomAngle)
        path.addLine(to: leftFrameBouncePoint)
        path.close()
        layers[1].frame = bounds
        layers[1].path = path.cgPath
        layers[1].lineWidth = 0
        layers[1].fillColor = UIColor.black.cgColor
    }
    
    func createInsideLayer(layer: CAShapeLayer) {
        let path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let radius = (frame.width / 2.0) - 20.0
        let midRadius = 0.55 * radius
        let leftBouncePoint = pointFrom(angle: .pi, radius: midRadius, offset: center)
        path.move(to: leftBouncePoint)
        path.addArc(withCenter: center, radius: midRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        path.addArc(withCenter: center, radius: midRadius, startAngle: 0, endAngle: .pi, clockwise: true)
        path.close()
        layer.frame = bounds
        layer.path = path.cgPath
        layer.lineWidth = 0
        layer.fillColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<pathList.count {
            self.createShieldPart(path: pathList[i], layer: layerList[i])
            angle += angleIncrement
        }
        self.createOutsideLayers(layers: [self.topOutsideLayer, self.bottomOutsideLayer])
        self.createInsideLayer(layer: self.insideLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            position = touch.location(in: self)
        }
        for i in 0..<pathList.count {
            if pathList[i].contains(position) {
                layerList[i].fillColor = touchesBeganAction?(i)
                layerList[i].opacity = 0.7
                break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0..<pathList.count {
            if pathList[i].contains(position) {
                layerList[i].fillColor = UIColor.clear.cgColor
                break
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0..<pathList.count {
            if pathList[i].contains(position) {
                layerList[i].fillColor = UIColor.clear.cgColor
                break
            }
        }
    }
    
    @objc
    private func shieldButtonPressed(_ sender: UITapGestureRecognizer? = nil) {
        for i in 0..<pathList.count {
            if pathList[i].contains(position) {
                pressAction?(i)
                break
            }
        }
    }
}
