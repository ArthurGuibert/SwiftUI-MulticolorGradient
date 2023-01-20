import SwiftUI

public struct MulticolorGradient: UIViewControllerRepresentable {
    internal var points: [ColorStop] = []
    private var bias: Float
    private var power: Float
    private var noise: Float
    private var colorInterpolation: ColorInterpolation
    
    public enum ColorInterpolation {
        case rgb, hsb
    }
    
    init(points: [ColorStop], bias: Float = 0.001, power: Float = 2.0, noise: Float = 0.05, colorInterpolation: ColorInterpolation = .rgb) {
        self.points = points
        self.bias = bias
        self.power = power
        self.noise = noise
        self.colorInterpolation = colorInterpolation
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MulticolorGradient>) -> MulticolorGradientViewController {
        let controller = MulticolorGradientViewController()
        controller.update(with: .init(points: points, bias: bias, power: power, noise: noise),
                          colorInterpolation: colorInterpolation)
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: MulticolorGradientViewController, context: UIViewControllerRepresentableContext<MulticolorGradient>) {
        
        if let animation = context.transaction.animation?.customMirror.children.first?.value {
            let params = MirrorAnimation.parse(mirror: Mirror(reflecting: animation))
            uiViewController.animate(to: .init(points: points, bias: bias, power: power, noise: noise), animation: params)
        } else {
            uiViewController.update(with: .init(points: points, bias: bias, power: power, noise: noise),
                                    colorInterpolation: colorInterpolation)
        }
    }
}

extension MulticolorGradient {
    public func bias(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: value, power: power, noise: noise, colorInterpolation: colorInterpolation)
    }
    
    public func power(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: value, noise: noise, colorInterpolation: colorInterpolation)
    }
    
    public func colorInterpolation(_ value: ColorInterpolation) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: power, noise: noise, colorInterpolation: value)
    }
    
    public func noise(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: power, noise: value, colorInterpolation: colorInterpolation)
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
