import SwiftUI

public struct MulticolorGradient: UIViewControllerRepresentable {
    internal var points: [ColorStop] = []
    private var bias: Float
    private var power: Float
    
    init(points: [ColorStop], bias: Float = 0.001, power: Float = 2.0) {
        self.points = points
        self.bias = bias
        self.power = power
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MulticolorGradient>) -> MulticolorGradientViewController {
        let controller = MulticolorGradientViewController()
        controller.points = points
        controller.bias = bias
        controller.power = power
        return controller
    }

    public func updateUIViewController(_ uiViewController: MulticolorGradientViewController, context: UIViewControllerRepresentableContext<MulticolorGradient>) {
        uiViewController.points = points
        uiViewController.power = power
        uiViewController.bias = bias
    }
}

extension MulticolorGradient {
    public func bias(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: value, power: power)
    }
    
    public func power(_ value: Float) -> Self {
        return MulticolorGradient(points: points, bias: bias, power: value)
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
