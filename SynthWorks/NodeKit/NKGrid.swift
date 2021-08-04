//
//  NKGrid.swift
//  NKGrid
//
//  Created by Riccardo Persello on 02/08/21.
//

import UIKit

@IBDesignable
/// A square grid, like the ones used in notebooks.
public class NKGrid: UIView {
    /// The spacing between the horizontal and vertical lines of the grid.
    @IBInspectable var gridSpacing: CGFloat = 20 {
        didSet {
            grid()
        }
    }

    /// The thickness of the lines that compose the grid.
    @IBInspectable var gridLineThickness: CGFloat = 1 {
        didSet {
            grid()
        }
    }

    /// The color of the lines that compose the grid.
    @IBInspectable var gridLineColor: UIColor = UIColor.systemGray5 {
        didSet {
            grid()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    /// Configures the view at initialization or when some properties change.
    /// It also does the first rendering of the view.
    private func configure() {
        backgroundColor = UIColor.clear
        grid()
    }

    /// Renders a layer containing the view and adds it as a sublayer.
    /// Removes all the old sublayers.
    private func grid() {
        layer.sublayers?.removeAll()

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

        gridLayer.strokeColor = gridLineColor.cgColor
        gridLayer.lineWidth = gridLineThickness

        gridLayer.path = gridPath.cgPath

        layer.addSublayer(gridLayer)
    }
}
