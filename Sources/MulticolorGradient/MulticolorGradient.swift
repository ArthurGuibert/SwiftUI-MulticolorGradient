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
    
    public init(points: [ColorStop], bias: Float = 0.001, power: Float = 2.0, noise: Float = 2.0, colorInterpolation: ColorInterpolation = .rgb) {
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
    
    /// Bias value to avoid artefacts, default is 0.001
    /// - Parameter value: bias value
    /// - Returns: a multicolor gradient with a bias value
    public func bias(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: value, power: power, noise: noise, colorInterpolation: colorInterpolation)
    }
    
    /// Value to adjust the spread of the blur, default is 2.0
    /// - Parameter value: power value
    /// - Returns: a multicolor gradient with a power value
    public func power(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: value, noise: noise, colorInterpolation: colorInterpolation)
    }
    
    
    /// Set in which domain the color interpolation is done
    /// - Parameter value: rgb or hsb
    /// - Returns: a multicolor gradient with a power value
    public func colorInterpolation(_ value: ColorInterpolation) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: power, noise: noise, colorInterpolation: value)
    }
    
    
    /// Set the percentage of noise that you want to add. Useful to avoid banding effect.
    /// - Parameter value: noise percentage
    /// - Returns: a multicolor gradient with a power value
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

    public static func buildArray(_ components: [[ColorStop]]) -> [ColorStop] {
        components.flatMap { $0 }
    }
    
    public static func buildIf(_ components: ColorStop?...) -> [ColorStop] {
        components.compactMap { $0 }
    }

    public static func buildEither(first component: [ColorStop]) -> [ColorStop] {
        component
    }

    public static func buildLimitedAvailability(_ component: [ColorStop]) -> [ColorStop] {
        component
    }

    public static func buildOptional(_ component: [ColorStop]?) -> [ColorStop] {
        component ?? []
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
