//
//  ExtraView.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 01.04.2023.
//

import UIKit

class ExtraView: UIView {
    // MARK: - Fields
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
        pathList = [self.pathNorth, self.pathNorthEast, self.pathEast, self.pathSouthEast, self.pathSouth, self.pathSouthWest, self.pathWest, self.pathNorthWest]
        layerList = [self.frontLayerNorth, self.frontLayerNorthEast, self.frontLayerEast, self.frontLayerSouthEast, self.frontLayerSouth, self.frontLayerSouthWest, self.frontLayerWest, self.frontLayerNorthWest]
        for i in 0..<pathList.count {
            layer.addSublayer(layerList[i])
        }
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
        layer.fillColor = UIColor.white.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<pathList.count {
            self.createShieldPart(path: pathList[i], layer: layerList[i])
            angle += angleIncrement
        }
    }
}
