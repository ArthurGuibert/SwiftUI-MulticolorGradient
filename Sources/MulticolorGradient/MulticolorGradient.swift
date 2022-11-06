import SwiftUI

public struct MulticolorGradient: UIViewControllerRepresentable {
    internal var points: [ColorStop] = []
    private var bias: Float
    private var power: Float
    private var colorInterpolation: ColorInterpolation
    
    public enum ColorInterpolation {
        case rgb, hsb
    }
    
    init(points: [ColorStop], bias: Float = 0.001, power: Float = 2.0, colorInterpolation: ColorInterpolation = .rgb) {
        self.points = points
        self.bias = bias
        self.power = power
        self.colorInterpolation = colorInterpolation
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MulticolorGradient>) -> MulticolorGradientViewController {
        let controller = MulticolorGradientViewController()
        controller.current.points = points
        controller.current.bias = bias
        controller.current.power = power
        controller.colorInterpolation = colorInterpolation
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: MulticolorGradientViewController, context: UIViewControllerRepresentableContext<MulticolorGradient>) {
        
        if let animation = context.transaction.animation?.customMirror.children.first?.value {
            let params = MirrorAnimation.parse(mirror: Mirror(reflecting: animation))
            uiViewController.animate(to: .init(points: points, bias: bias, power: power), animation: params)
        } else {
            uiViewController.current.points = points
            uiViewController.current.power = power
            uiViewController.current.bias = bias
        }
    }
}

extension MulticolorGradient {
    public func bias(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: value, power: power, colorInterpolation: colorInterpolation)
    }
    
    public func power(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: value, colorInterpolation: colorInterpolation)
    }
    
    public func colorInterpolation(_ value: ColorInterpolation) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: power, colorInterpolation: value)
    }
}

public struct ColorStop {
    let position: UnitPoint
    let color: Color
    
    public init(position: UnitPoint, color: Color) {
        self.position = position
        self.color = color
    }
}

@resultBuilder
public struct MulticolorGradientPointBuilder {
    public static func buildBlock(_ cells: ColorStop...) -> [ColorStop] {
      Array(cells)
    }
}

extension MulticolorGradient {
    public init(@MulticolorGradientPointBuilder _ content: () -> [ColorStop]) {
      self.init(points: content())
    }
    
    public init(@MulticolorGradientPointBuilder _ content: () -> ColorStop) {
      self.init(points: [content()])
    }
}
