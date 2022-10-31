import XCTest
import SwiftUI
@testable import MulticolorGradient

extension MulticolorGradientPoint: Equatable {
    public static func == (lhs: MulticolorGradientPoint, rhs: MulticolorGradientPoint) -> Bool {
        return lhs.position == rhs.position && lhs.color == rhs.color
    }
}

final class MulticolorGradientTests: XCTestCase {
    func testThatTheResultBuilderIsBuildingTwoPoints() throws {
        let view = MulticolorGradient {
            MulticolorGradientPoint(position: .top,
                                    color: .init(red: 1.0, green: 0.0, blue: 1.0))
            MulticolorGradientPoint(position: .bottom,
                                    color: .init(red: 1.0, green: 0.0, blue: 0.0))
        }
        
        XCTAssertEqual(view.points[0], MulticolorGradientPoint(position: .top,
                                                               color: .init(red: 1.0, green: 0.0, blue: 1.0)))
        XCTAssertEqual(view.points[1], MulticolorGradientPoint(position: .bottom,
                                                               color: .init(red: 1.0, green: 0.0, blue: 0.0)))
        
    }
}
