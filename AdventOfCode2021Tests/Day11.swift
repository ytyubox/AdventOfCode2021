import Foundation
import XCTest

final class Day11Tests: XCTestCase {
    func test() throws {
        page1(input: smallInput, step: 2, shouldBe: 9)
        page1(input: demoInput, step: 100, shouldBe: 1656)
        page1(input: input, step: 100, shouldBe: 1679)
        page2(input: demoInput, shouldBe: 195)
        page2(input: input, shouldBe: 519)
    }
    func page1(input: Input, step: Int, shouldBe: Int) {
        
        let sut = input.map{
            s in
            s.s.compactMap(Int.init).map(Octopus.init)
        }
        let board = Board(sut)
        var counts:[Int] = []
        for _ in 1...step {
            var ingSet:Set<Point> = []
            for (x, y) in board.indices {
                board[y, x].incr()
                if board[y, x].flashed == .ing {ingSet.insert(Point(x,y))}
            }
            while true {
                if ingSet.isEmpty {break}
                var tempSet = ingSet
                for p in ingSet {
                    tempSet.remove(p)
                    board[p.y, p.x].flashed = .did
                    for ap in adjacent(p.x, p.y, l: board.l, w: board.w) {
                        if board[ap.y, ap.x].flashed == .ing {continue}
                        board[ap.y, ap.x].incr()
                        if board[ap.y, ap.x].flashed == .ing {
                            tempSet.insert(Point(ap.x,ap.y))
                        }
                    }
                }
                ingSet = tempSet
            }
            
            var count = 0
            
            for (x,y) in board.indices where board[y, x].flashed == .did {
                count += 1
            }
            counts.append(count)
            for i in board.array.indices {
                board.array[i].flashed = .no
            }
        }
        counts.sum().shouldBe(shouldBe)
    }
    func page2(input: Input, shouldBe: Int) {
        
        let sut = input.map{
            s in
            s.s.compactMap(Int.init).map(Octopus.init)
        }
        let board = Board(sut)
        var step = 1
        while true {
            var ingSet:Set<Point> = []
            for (x, y) in board.indices {
                board[y, x].incr()
                if board[y, x].flashed == .ing {ingSet.insert(Point(x,y))}
            }
            while true {
                if ingSet.isEmpty {break}
                var tempSet = ingSet
                for p in ingSet {
                    tempSet.remove(p)
                    board[p.y, p.x].flashed = .did
                    for ap in adjacent(p.x, p.y, l: board.l, w: board.w) {
                        if board[ap.y, ap.x].flashed == .ing {continue}
                        board[ap.y, ap.x].incr()
                        if board[ap.y, ap.x].flashed == .ing {
                            tempSet.insert(Point(ap.x,ap.y))
                        }
                    }
                }
                ingSet = tempSet
            }
           
            if board.array.allSatisfy({
                $0.flashed == .did
            }) {break}
           
            for i in board.array.indices {
                board.array[i].flashed = .no
            }
            step += 1
        }
        step.shouldBe(shouldBe)
    }
    func testAdjacent() throws {
        adjacent(2, 2, l: 4, w: 4).shouldBe(
            [Point(3,3),
             Point(3,2),
             Point(3,1),
             Point(1,1),
             Point(1,2),
             Point(1,3),
             Point(2,3),
             Point(2,1)]
        )
        adjacent(0, 0, l: 3, w:3).shouldBe(
            [Point(0,1),
             Point(1,0),
             Point(1,1),
             ]
        )
    }
}

func adjacent(_ x: Int, _ y: Int, l: Int, w: Int) -> Set<Point> {
    
    [
        Point(x+1, y+1),
        Point(x+1, y),
        Point(x+1, y-1),
        Point(x-1, y+1),
        Point(x-1, y),
        Point(x-1, y-1),
        Point(x, y+1),
        Point(x, y-1),
    ]
        .filter{
            (0..<w).contains($0.x) &&
            (0..<l).contains($0.y)
        }
        .set()
}

private let smallInput: Input =
"""
11111
19991
19191
19991
11111
"""

class Octopus:CustomStringConvertible {
    
    var description: String {
        """
        \(value > 9 ? 0 : value)
        """
    }

    internal init(_ value: Int) {
        self.value = value
    }
    var value: Int
    enum Flash {case no, ing, did}
    var flashed:Flash = .no
    func incr() {
        if flashed == .did {return}
        if value >= 9 {
            value = 0
            flashed = .ing
        }
        else {
            value += 1
        }
    }
}

extension Board {
    internal init(_ array: [[T]]) {
        let w = array.first!.count
        let l = array.count
        self.init(w: w, l: l, array: array.flatMap({$0}))
    }
    var xIndices: Range<Int>  {0..<w}
    var YIndices: Range<Int> {0..<l}
}



struct BoardIter: IteratorProtocol, Sequence {
    let l:Int, w:Int
    func makeIterator() -> BoardIter {
        self
    }
    typealias Element = (Int, Int)
    var x = -1, y = 0
    mutating func next() -> (Int, Int)? {
        if (x + 1) == w {
            x = -1
            y += 1
        }
        guard (y) < l else {return nil}
        x += 1
        return (x, y)
    }
}
extension Board {
    var indices: BoardIter {
        BoardIter(l: l, w: w)
    }
}

final class BoardTests: XCTestCase {
    func test() throws {
        let sut = BoardIter(l: 1, w: 3)
        var history:[Point] = []
        for (x,y) in sut {
            history.append(Point(x,y))
        }
        history.shouldBe(
            [
                Point(0,0), Point(1,0), Point(2,0),
            ]
        )
    }
    func test2() throws {
        let sut = BoardIter(l: 2, w: 3)
        var history:[Point] = []
        for (x,y) in sut {
            history.append(Point(x,y))
        }
        history.shouldBe(
            [
                Point(0,0), Point(1,0), Point(2,0),
                Point(0,1), Point(1,1), Point(2,1),
            ]
        )
    }
}

private let demoInput: Input =
"""
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

private let input: Input =
"""
1553421288
5255384882
1224315732
4258242274
1658564216
6872651182
5775552238
5622545172
8766672318
2178374835
"""
