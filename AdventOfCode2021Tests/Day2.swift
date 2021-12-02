import Foundation
import XCTest

final class Day2Tests: XCTestCase {
    func test() throws {
        let sut = input.map(Dive.init)
        var i = 0, j = 0
        for d in sut {
            switch d {
            case .forward(let int):
                i += int
            case .down(let int):
                j += int
            case .up(let int):
                j -= int
            }
        }
        assertEqual(i*j, 2322630)
    }
    func testPage2() throws {
        let sut = input.map(Dive.init)
        let (h, _, d) =
        sut.reduce(into: (0,0,0)) { d, dive in
            print(d)
            switch dive {
            case .forward(let int):
                d.0 += int
                d.2 += d.1*int
            case .down(let int):
                d.1 += int
            case .up(let int):
                d.1 -= int
            }
        }
        
        assertEqual(h*d, 2105273490)
    }
    private enum Dive {
        init(_ c: String) {
            let c = c.split(separator: " ").map(\.description)
            switch c[0] {
            case "forward": self = .forward(Int(c[1])!)
            case "down": self = .down(Int(c[1])!)
            case "up": self = .up(Int(c[1])!)
            default: fatalError()
            }
        }
        case forward(Int), down(Int), up(Int)
    }
}

private let input: Input = """
forward 6
down 2
forward 2
down 8
forward 3
down 6
down 8
down 9
forward 7
forward 8
down 9
down 8
down 9
up 8
forward 1
down 7
down 3
forward 3
forward 1
down 3
forward 3
forward 1
up 8
down 5
down 1
forward 6
forward 2
up 9
down 3
down 8
down 3
down 3
up 2
down 7
down 3
up 5
forward 4
down 9
forward 6
forward 3
forward 1
forward 3
down 2
up 9
down 4
forward 6
down 3
forward 2
down 2
up 5
up 1
forward 3
forward 6
down 6
forward 7
forward 1
down 3
down 8
forward 2
down 7
up 1
up 2
forward 5
down 8
down 8
forward 9
forward 7
forward 2
forward 7
up 6
up 9
down 4
forward 4
forward 4
up 1
down 7
forward 9
forward 3
down 6
down 9
forward 7
forward 4
up 7
up 6
up 8
down 9
forward 1
down 1
forward 8
down 7
forward 5
down 3
down 3
down 8
down 8
down 4
up 4
forward 3
down 8
down 9
up 3
up 8
down 9
up 5
forward 2
forward 5
forward 5
down 8
forward 9
forward 8
down 5
down 9
forward 6
forward 2
forward 3
up 1
forward 1
up 2
up 2
forward 4
forward 8
forward 5
down 1
up 4
forward 5
up 7
down 5
down 5
forward 8
up 2
down 7
down 6
down 5
down 5
down 1
down 8
forward 9
forward 2
up 6
up 4
down 8
forward 1
forward 2
down 2
forward 7
forward 7
forward 3
forward 6
forward 8
down 3
forward 6
up 5
down 3
down 8
up 1
forward 1
down 7
down 3
up 5
forward 6
forward 8
forward 9
up 5
up 5
up 5
forward 8
up 5
down 6
down 7
down 5
up 7
up 1
up 3
forward 8
up 9
down 7
down 4
up 6
up 8
up 9
up 9
forward 5
up 5
forward 2
forward 2
forward 6
up 2
down 8
up 2
forward 5
down 9
up 7
down 9
forward 1
forward 8
up 1
forward 7
forward 2
down 3
forward 3
forward 2
up 9
forward 4
forward 9
down 9
forward 5
forward 1
forward 5
forward 8
up 5
forward 1
down 4
up 8
up 4
up 7
forward 4
down 1
up 6
forward 6
down 2
down 7
forward 4
up 7
forward 7
forward 9
down 5
up 5
forward 4
down 6
forward 1
up 8
up 8
down 8
down 7
forward 7
down 3
forward 7
down 3
down 5
down 4
up 8
down 2
down 2
up 5
forward 9
up 9
forward 2
up 4
forward 4
down 2
down 7
forward 7
down 1
down 6
down 4
forward 6
up 4
forward 4
down 6
down 8
down 3
forward 7
down 3
forward 7
down 7
forward 4
up 9
down 5
forward 7
forward 7
up 6
down 3
forward 9
down 1
forward 4
up 9
down 3
up 9
down 5
up 6
forward 1
forward 9
up 4
down 3
forward 1
down 7
down 2
forward 2
down 6
up 4
down 4
up 9
down 3
down 9
down 4
down 1
up 8
down 2
up 1
forward 5
forward 9
forward 1
up 4
forward 5
down 7
up 6
down 3
forward 8
down 1
down 5
forward 5
down 5
down 7
down 8
down 7
up 6
forward 8
down 8
forward 6
down 6
down 7
down 3
forward 2
down 6
down 8
down 7
down 3
up 1
down 7
forward 8
forward 2
forward 5
down 4
up 4
forward 9
down 9
forward 6
down 7
down 4
down 8
up 9
forward 7
down 4
forward 7
forward 1
forward 7
down 9
down 7
forward 3
forward 3
forward 2
down 5
up 5
forward 5
down 2
forward 7
forward 9
forward 7
down 7
down 9
down 5
forward 2
up 5
down 3
forward 7
down 4
down 3
up 5
down 6
down 3
up 4
forward 3
down 1
forward 6
forward 6
down 8
forward 9
down 2
up 3
down 4
down 5
forward 3
down 9
forward 2
up 3
up 4
forward 9
down 2
forward 9
forward 3
down 4
down 2
down 5
down 4
forward 4
down 1
down 9
down 2
forward 8
down 5
forward 5
up 7
down 5
down 2
forward 5
up 4
down 5
up 3
forward 7
down 9
forward 5
forward 2
forward 1
down 7
down 9
down 2
up 2
up 2
up 4
down 4
down 7
down 3
forward 5
forward 3
up 6
down 6
up 6
up 9
forward 8
forward 4
up 3
forward 1
forward 2
up 5
forward 5
forward 8
forward 7
forward 4
down 1
down 8
down 1
forward 3
up 1
forward 7
forward 4
down 8
forward 7
forward 9
forward 3
down 9
down 9
down 3
up 6
up 1
down 4
forward 5
forward 4
forward 6
forward 8
down 6
down 3
forward 5
forward 6
down 4
down 2
up 3
down 3
down 7
down 5
down 5
forward 6
down 4
forward 1
up 2
forward 3
down 1
down 4
down 9
down 7
down 9
forward 9
down 6
down 3
down 2
down 5
up 8
forward 5
forward 5
forward 4
up 5
forward 1
down 9
down 1
up 5
forward 8
forward 6
forward 5
down 1
up 5
down 8
up 7
down 8
down 2
down 3
forward 2
up 4
down 6
up 6
down 3
down 7
up 3
forward 4
down 3
forward 4
up 9
forward 5
down 2
forward 7
forward 5
up 3
up 2
forward 2
down 8
down 1
down 3
up 5
down 4
forward 4
down 1
forward 9
down 3
down 7
down 4
down 4
forward 7
up 5
forward 4
down 8
up 4
forward 6
down 1
up 4
forward 4
down 6
up 5
up 1
forward 2
down 5
forward 8
forward 6
down 8
down 7
down 7
down 1
forward 5
forward 7
forward 7
forward 7
up 3
forward 9
forward 1
down 9
forward 4
up 8
forward 1
forward 5
forward 4
down 2
forward 4
forward 9
forward 3
down 1
forward 4
forward 9
forward 5
down 5
down 5
forward 7
down 3
forward 4
down 6
forward 7
down 2
down 1
down 5
forward 4
forward 9
down 4
forward 2
down 8
up 5
down 9
forward 8
down 3
up 6
down 2
down 4
forward 4
up 2
down 4
down 4
up 7
down 6
forward 4
down 7
forward 3
down 1
up 1
down 2
down 6
down 4
up 3
down 6
up 2
down 6
forward 3
down 9
forward 5
down 5
down 9
down 9
down 7
forward 9
forward 8
forward 9
up 9
forward 7
forward 4
forward 4
up 5
forward 2
down 1
up 9
forward 2
forward 7
forward 1
down 9
forward 9
up 8
up 1
up 7
up 7
down 5
forward 2
forward 8
forward 6
down 7
forward 1
down 9
down 4
down 4
down 1
up 7
forward 4
forward 6
up 5
forward 2
down 9
down 7
forward 1
forward 2
down 5
forward 3
forward 8
forward 6
forward 3
forward 2
down 1
forward 1
forward 1
forward 3
down 9
up 9
down 9
down 6
forward 7
down 6
forward 9
down 9
down 7
down 1
down 9
up 9
down 6
forward 9
down 6
forward 3
down 8
up 5
forward 5
forward 8
up 3
down 8
up 6
forward 4
down 2
forward 6
down 9
forward 6
forward 4
forward 9
forward 3
down 2
down 4
forward 5
down 9
up 7
forward 4
up 1
forward 1
down 6
forward 3
forward 7
forward 2
forward 2
down 5
down 9
down 3
down 5
up 3
forward 1
down 2
down 4
down 1
up 9
up 5
up 1
down 1
up 9
down 5
up 3
up 3
down 7
forward 4
down 6
forward 2
forward 7
forward 4
down 2
forward 6
forward 2
down 3
up 3
up 9
forward 9
forward 9
forward 6
down 8
down 1
forward 9
up 1
down 6
forward 6
up 5
forward 2
forward 6
down 9
forward 1
forward 8
down 8
forward 4
forward 7
up 6
up 1
forward 7
forward 3
forward 2
down 4
down 7
down 7
down 1
down 6
forward 1
down 9
up 9
up 9
down 2
down 2
forward 5
up 2
forward 7
up 5
down 9
forward 7
forward 2
down 8
up 1
down 5
forward 6
down 8
down 7
forward 4
up 2
down 8
forward 2
down 5
down 4
down 9
down 1
down 9
down 6
down 3
forward 1
forward 6
up 1
up 1
up 9
down 2
down 2
forward 5
down 3
forward 4
down 3
down 7
down 7
forward 4
up 3
forward 4
down 3
forward 8
forward 1
up 2
up 1
forward 1
down 6
down 1
down 3
forward 7
down 7
forward 4
forward 5
forward 3
down 5
forward 9
forward 5
down 7
forward 6
down 4
down 4
down 9
down 3
up 9
forward 7
down 7
forward 6
down 2
down 9
forward 4
forward 1
forward 4
down 5
forward 7
down 9
down 8
forward 9
forward 1
down 9
forward 6
up 5
forward 9
down 1
down 5
forward 4
forward 5
forward 8
down 5
forward 9
down 6
down 2
up 4
up 8
forward 3
forward 4
down 3
forward 4
up 6
forward 3
forward 8
forward 7
down 1
down 9
down 8
down 8
down 1
forward 9
up 4
down 5
forward 7
down 8
down 3
forward 9
down 5
forward 7
forward 2
down 4
forward 2
forward 7
down 6
forward 7
down 2
forward 9
down 9
forward 8
forward 8
down 6
forward 7
down 8
forward 7
forward 3
down 1
up 8
down 5
down 6
up 5
forward 5
forward 5
up 5
up 3
up 7
down 6
forward 8
forward 4
down 2
up 5
forward 8
down 6
forward 4
forward 2
up 8
down 8
down 5
down 4
forward 9
forward 9
forward 6
forward 6
down 3
up 1
down 4
down 8
down 9
down 1
forward 3
forward 1
down 9
down 3
down 7
forward 6
forward 9
down 8
down 8
forward 6
forward 1
down 3
forward 1
down 8
down 3
down 9
up 1
forward 6
up 2
down 3
forward 4
forward 2
up 2
down 5
forward 1
down 3
forward 9
forward 4
forward 6
down 3
forward 7
down 6
up 3
up 7
up 5
down 4
forward 4
up 1
forward 7
up 9
forward 3
up 1
down 3
down 4
forward 4
up 3
down 6
down 9
down 6
forward 4
down 9
down 6
forward 4
forward 3
down 3
up 7
down 9
forward 8
"""
