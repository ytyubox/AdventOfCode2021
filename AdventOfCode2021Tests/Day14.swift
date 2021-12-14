import Foundation
import XCTest
class LinkList: CustomStringConvertible {
    internal init(_ val: String, next: LinkList? = nil) {
        self.val = val
        self.next = next
    }

    var val: String
    var next: LinkList?
    var description: String {
        var r = val
        var ptr: LinkList? = self
        while true {
            ptr = ptr?.next
            guard let ptr = ptr else { break }
            r += ptr.val
        }
        return r
    }
}

final class Day14Tests: XCTestCase {
    func test() throws {
        page1(input: demoInput, step: 10, shouldBe: 1588)
//        print()
//        page1(input: input, step: 10, shouldBe: 3587)
//        print()
        page1(input: input, step: 40, shouldBe: 3_906_445_077_998)
    }

    func page1(input: String, step: Int, shouldBe: Int) {
        let sut = Polymer(str: input)

        var dic1 = zipPair(sut.polymer).map { [$0.a, $0.b] }.group().mapValues(\.count)
        for _ in 1 ... step {
            var temp: [[String]: Int] = [:]
            for (k, v) in dic1 {
                let c = sut.lookup[k.joined()]!
                temp[[k[0], c], default: 0] += v
                temp[[c, k[1]], default: 0] += v
            }
            dic1 = temp
        }

        var dic2: [String: Int] = [:]
        for (k, v) in dic1 {
            dic2[k[1], default: 0] += v
            dic2[k[0], default: 1] += v
        }

        var MAX = Int.min, MIN = Int.max
        for c in dic2.values {
            MAX = max(c / 2, MAX)
            MIN = min(c / 2, MIN)
        }
        (MAX - MIN).shouldBe(shouldBe)
    }

    func testPolymer() throws {
        let sut = Polymer(str: demoInput)
        sut.polymer.description.shouldBe("NNCB")
        sut.lookup.shouldBe(
            [
                "CH": "B",
                "HH": "N",
                "CB": "H",
                "NH": "C",
                "HB": "C",
                "HC": "B",
                "HN": "C",
                "NN": "C",
                "BH": "H",
                "NC": "B",
                "NB": "B",
                "BN": "B",
                "BB": "N",
                "BC": "B",
                "CC": "N",
                "CN": "C",
            ])
    }

    func testZipPair() throws {
        let array = [1, 2, 3]
        zipPair(array).shouldBe([Pair(1, 2), Pair(2, 3)])
    }
}

func linkedList(_ array: [String]) -> LinkList {
    let h = LinkList(array.first!)
    var t = h
    let array = array.dropFirst()
    for e in array {
        let x = LinkList(e)
        t.next = x
        t = x
    }

    return h
}

struct Polymer {
    internal init(str: String) {
        let str = str.components(separatedBy: "\n\n")
        polymer = str[0].s
        let list = str[1].components(separatedBy: "\n")
            .map { $0.components(separatedBy: " -> ") }
        var lookup: [String: String] = [:]
        for p in list {
            lookup[p[0]] = p[1]
        }
        self.lookup = lookup
    }

    var polymer: [String]
    var lookup: [String: String]
}

func zipPair<T>(_ array: [T]) -> [Pair<T, T>] {
    let _2 = array.dropFirst()
    return Array(zip(array, _2)).map(Pair.init)
}

struct Pair<A, B> {
    internal init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }

    internal init(pair: (A, B)) {
        a = pair.0
        b = pair.1
    }

    let a: A, b: B
}

extension Pair: Equatable where A: Equatable, B: Equatable {}
extension Pair: CustomStringConvertible where A: CustomStringConvertible, B: CustomStringConvertible {
    var description: String {
        "Pair(\(a), \(b))"
    }
}

private let demoInput =
    """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """

private let input =
    """
    PBVHVOCOCFFNBCNCCBHK

    FV -> C
    SS -> B
    SC -> B
    BP -> K
    VP -> S
    HK -> K
    FS -> F
    CC -> V
    VB -> P
    OP -> B
    FO -> N
    FH -> O
    VK -> N
    PV -> S
    HV -> O
    PF -> F
    HH -> F
    NK -> S
    NC -> S
    FC -> H
    FK -> K
    OO -> N
    HP -> C
    NN -> H
    BB -> H
    CN -> P
    PS -> N
    VF -> S
    CB -> B
    OH -> S
    CF -> C
    OK -> P
    CV -> V
    CS -> H
    KN -> B
    OV -> S
    HB -> C
    OS -> V
    PC -> B
    CK -> S
    PP -> K
    SN -> O
    VV -> C
    NS -> F
    PN -> K
    HS -> P
    VO -> B
    VC -> B
    NV -> P
    VS -> N
    FP -> F
    HO -> S
    KS -> O
    BN -> F
    VN -> P
    OC -> K
    SF -> P
    PO -> P
    SB -> O
    FN -> F
    OF -> F
    CP -> C
    HC -> O
    PH -> O
    BC -> O
    NO -> C
    BH -> C
    VH -> S
    KK -> O
    SV -> K
    KB -> K
    BS -> S
    HF -> B
    NH -> S
    PB -> N
    HN -> K
    SK -> B
    FB -> F
    KV -> S
    BF -> S
    ON -> S
    BV -> P
    KC -> S
    NB -> S
    NP -> B
    BK -> K
    NF -> C
    BO -> K
    KF -> B
    KH -> N
    SP -> O
    CO -> S
    KO -> V
    SO -> B
    CH -> C
    KP -> C
    FF -> K
    PK -> F
    OB -> H
    SH -> C
    """
