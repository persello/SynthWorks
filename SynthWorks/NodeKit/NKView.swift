import UIKit

@IBDesignable
public class NKView: UIScrollView {
    private let backgroundGrid: NKGrid! = NKGrid(frame: CGRect(x: 0, y: 0, width: 5000, height: 5000))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    func render() {
        
    }
    
    func configure() {
        clipsToBounds = true
        minimumZoomScale = 0.25
        maximumZoomScale = 4.0
        
        delegate = self
        
        addSubview(backgroundGrid)
        
        setContentOffset(CGPoint(x: backgroundGrid.frame.midX, y: backgroundGrid.frame.midY), animated: false)
    }
}

extension NKView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundGrid
    }
}

extension NKView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        render()
    }
    
    public override func didMoveToSuperview() {
        configure()
    }
}
