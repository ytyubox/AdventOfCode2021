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
struct Input: ExpressibleByStringLiteral, Sequence, CustomStringConvertible {
    var description: String {array.joined(separator: "\n")}
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

extension Array {
    func group<Key: Hashable>(_ keyForValue: (Element) throws -> Key) rethrows -> [Key: [Element]] {
        try Dictionary.init(grouping: self, by: keyForValue)
    }
    func sum() -> Int where Element == Int {
        reduce(0, +)
    }
    func product() -> Int where Element == Int {
        reduce(into: 1, *=)
    }
}
