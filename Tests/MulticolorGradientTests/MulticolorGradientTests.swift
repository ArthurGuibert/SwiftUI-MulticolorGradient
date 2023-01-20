import XCTest
import SwiftUI
@testable import MulticolorGradient

extension ColorStop: Equatable {
    public static func == (lhs: ColorStop, rhs: ColorStop) -> Bool {
        return lhs.position == rhs.position && lhs.color == rhs.color
    }
}

final class MulticolorGradientTests: XCTestCase {
    func testThatTheResultBuilderIsBuildingTwoPoints() throws {
        let view = MulticolorGradient {
            ColorStop(position: .top,
                      color: .init(red: 1.0, green: 0.0, blue: 1.0))
            ColorStop(position: .bottom,
                      color: .init(red: 1.0, green: 0.0, blue: 0.0))
        }
        
        XCTAssertEqual(view.points[0], ColorStop(position: .top,
                                                 color: .init(red: 1.0, green: 0.0, blue: 1.0)))
        XCTAssertEqual(view.points[1], ColorStop(position: .bottom,
                                                 color: .init(red: 1.0, green: 0.0, blue: 0.0)))
        
    }
}
