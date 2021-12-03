import Foundation
import CustomDump
func assertEqual<T>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) where T: Equatable {
      CustomDump.XCTAssertNoDifference(try expression1(), try expression2(), message(), file: file, line: line)
}
struct Input: ExpressibleByStringLiteral, Sequence {
    let array: [String]
    
    init(stringLiteral value: String) {
        array = value.split(separator: "\n").map(\.description)
    }
    
    typealias Iterator = IndexingIterator<[Element]>
    typealias Element = String
    func makeIterator() -> Iterator {
        array.makeIterator()
    }
}