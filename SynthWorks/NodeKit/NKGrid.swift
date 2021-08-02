//
//  File.swift
//  File
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

@IBDesignable
class NKGrid: UIView {
    @IBInspectable var gridSpacing: CGFloat = 20 {
        didSet {
            grid()
        }
    }

    @IBInspectable var gridThickness: CGFloat = 1 {
        didSet {
            grid()
        }
    }

    @IBInspectable var gridLineColor: UIColor = UIColor.systemGray4 {
        didSet {
            grid()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    func configure() {
        backgroundColor = UIColor.clear
        grid()
    }

    func grid() {
        let gridLayer = CAShapeLayer()
        let gridPath = UIBezierPath()

        let rows: Int = Int(floor(frame.height / gridSpacing))
        let cols: Int = Int(floor(frame.width / gridSpacing))

        for i in 0 ... cols {
            let x = CGFloat(i) * gridSpacing
            gridPath.move(to: CGPoint(x: x, y: 0))
            gridPath.addLine(to: CGPoint(x: x, y: frame.height))
        }

        for i in 0 ... rows {
            let y = CGFloat(i) * gridSpacing
            gridPath.move(to: CGPoint(x: 0, y: y))
            gridPath.addLine(to: CGPoint(x: frame.width, y: y))
        }

        // TODO: Let users customize properties
        gridLayer.strokeColor = gridLineColor.cgColor
        gridLayer.lineWidth = gridThickness

        gridLayer.path = gridPath.cgPath

        layer.addSublayer(gridLayer)
    }
}
