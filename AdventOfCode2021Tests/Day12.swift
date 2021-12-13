import CoreMotion
import Foundation
import SwiftUI
import XCTest

final class Day12Tests: XCTestCase {
    func testPage1() throws {
        page1(input: smallInput, shouldBe: 10)
        page1(input: slightlyLargerInput, shouldBe: 19)
        page1(input: evenLargerExample, shouldBe: 226)
        page1(input: input, shouldBe: 3421)
        page2(input: smallInput, shouldBe: 36)
//        page2(input: slightlyLargerInput, shouldBe: 103)
//        page2(input: evenLargerExample, shouldBe: 3509)
        page2(input: input, shouldBe: 84870)
    }

    func page1(input: Input, shouldBe: Int) {
        let lines = input.map(Line12.init(line:))
        let nodes = lines.reduce(Set()) {
            $0.union($1.endPoints)
        }

        var nodeDic: [String: [String]] = [:]
        for n in nodes {
            nodeDic[n, default: []] = lines
                .filter { $0.endPoints.contains(n) }
                .flatMap(\.endPoints)
                .filter { $0 != n }
        }
        getPath(dic: nodeDic, canVisit: 1).count.shouldBe(shouldBe)
    }

    func page2(input: Input, shouldBe: Int) {
        let lines = input.map(Line12.init(line:))
        let nodes = lines.reduce(Set()) {
            $0.union($1.endPoints)
        }

        var nodeDic: [String: [String]] = [:]
        for n in nodes {
            nodeDic[n, default: []] = lines
                .filter { $0.endPoints.contains(n) }
                .flatMap(\.endPoints)
                .filter { $0 != n }
        }

        func paths(_ n: String, visited: Set<String>, mult: Bool, cave: String) -> Int {
            if n == END { return 1 }
            if n == START, !visited.isEmpty { return 0 }
            if n.isSmall, visited.contains(n), !mult {
                return 0
            }
            var cave = cave
            if n.isSmall, visited.contains(n), mult {
                if cave == "" { cave = n }
                else { return 0 }
            }
            var poss = 0
            for r in nodeDic[n]! {
                poss += paths(r, visited: visited.union([n]), mult: mult, cave: cave)
            }
            return poss
        }

        paths(START, visited: Set(), mult: true, cave: "").shouldBe(shouldBe)
    }

    private func getPath(dic: [String: [String]], canVisit: Int) -> Set<[String]> {
        var paths: [[String]] = []
        func getSubRoute(_ n: String, visited: [String: Int], path: [String]) {
            var path = path, visited = visited
            if n.isSmall { visited[n, default: 0] += 1 }
            path.append(n)
            if n == END { return paths.append(path) }
            for i in dic[n]! {
                if visited[i, default: 0] == canVisit { continue }
                getSubRoute(i, visited: visited, path: path)
            }
        }
        getSubRoute(START, visited: [START: canVisit], path: [])
        return paths.set()
    }

    func testFilter() throws {
        let sut = "start,A,b,A,b,A,c,A,c,A,end".components(separatedBy: ",")
        sut.filter(\.isSmall)
            .group { $0 }.mapValues(\.count)
            .map(\.value).count
            .shouldBe(2)
    }
}

private let START = "start", END = "end"
struct Node12 {
    let ID: String
}

struct Line12: Equatable, CustomStringConvertible {
    internal init(line: String) {
        endPoints = line.components(separatedBy: "-").set()
    }

    let endPoints: Set<String>
    var description: String {
        "Line12(\(endPoints))"
    }
}

private let smallInput: Input =
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

extension String {
    var isSmall: Bool {
        self != START &&
            self != END &&
            allSatisfy(\.isLowercase)
    }
}

private let slightlyLargerInput: Input =
    """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

private let input: Input =
    """
    rf-RL
    rf-wz
    wz-RL
    AV-mh
    end-wz
    end-dm
    wz-gy
    wz-dm
    cg-AV
    rf-AV
    rf-gy
    end-mh
    cg-gy
    cg-RL
    gy-RL
    VI-gy
    AV-gy
    dm-rf
    start-cg
    start-RL
    rf-mh
    AV-start
    qk-mh
    wz-mh
    """

let evenLargerExample: Input =
    """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """
