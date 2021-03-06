import Foundation
import XCTest

final class Day10Tests: XCTestCase {
    func test() throws {
        page1(input: inputDemo, shouldBe: 26397)
        page1(input: input, shouldBe: 392_421)
        page2(input: inputDemo, shouldBe: 288_957)
        page2(input: input, shouldBe: 2_769_449_099)
    }

    func page1(input: Input, shouldBe: Int) {
        input.map(Chuck.init)
            .compactMap(\.isCorrupted)
            .compactMap { valueLoopup[$0] }
            .sum()
            .shouldBe(shouldBe)
    }

    func page2(input: Input, shouldBe: Int) {
        let sut = input.map(Chuck.init)
            .filter { $0.isCorrupted == nil }
            .map(\.score)
            .sorted()
        sut[sut.count / 2].shouldBe(shouldBe)
    }

    func testChunk() throws {
        let sut = Chuck("{([(<{}[<>[]}>{[]{[(<()>")
        sut.isCorrupted?.shouldBe("}")
        let sut2 = Chuck("[({(<(())[]>[[{[]{<()<>>")
        sut2.score
            .shouldBe(288_957)
    }
}

let valueLoopup: [String: Int] = [
    ")": 3,
    "]": 57,
    "}": 1197,
    ">": 25137,
]
let lookup: [String: String] =
    [
        ")": "(",
        "]": "[",
        "}": "{",
        ">": "<",
    ]
let revLoopUp = [
    "(": ")",
    "[": "]",
    "{": "}",
    "<": ">",
]
let scorelookup = [
    ")": 1,
    "]": 2,
    "}": 3,
    ">": 4,
]
let addKeys = lookup.values.map(\.description).set()

struct Chuck: Equatable, CustomStringConvertible {
    var description: String {
        """
        Chuck("\(array.joined())")
        """
    }

    internal init(_ line: String) {
        array = line.s
    }

    internal init(array: [String]) {
        self.array = array
    }

    let array: [String]
    var isCorrupted: String? {
        var stack: [String] = []

        for c in array {
            if addKeys.contains(c) {
                stack.append(c)
                continue
            }
            guard let last = stack.popLast() else { continue }
            if lookup[c]! != last { return c }
        }
        return nil
    }

    var remaid: String {
        var stack: [String] = []

        for c in array {
            if addKeys.contains(c) {
                stack.append(c)
                continue
            }
            guard let last = stack.popLast() else { continue }
            if lookup[c]! != last {
                stack.append(last)
                continue
            }
        }
        return stack.map { revLoopUp[$0]! }.reversed().joined()
    }

    var score: Int {
        remaid
            .map(\.description)
            .map { scorelookup[$0]! }
            .reduce(into: 0) {
                o, x in
                o = (o * 5) + x
            }
    }
}

private let inputDemo: Input =
    """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

private let input: Input =
    """
    <<{<[<<<{<<(<({}())({}[]))[[{}[]]<{}[]>])[<[{}[]]{()()}>{((){})<<><>>}]>>[<(<<{}>>[<()()><<><>>]
    {[[[{<[(([[{(({}))([<>[]]((){}))}<<<[][]>[{}{}]>[{()[]}(()())]>][[[{<>()}[{}[]]]]]]<{{{{()[]}}}[[{[][]}{{
    ([((<(<(<<([{{[][]}([]<>)}({<>{}}[[]()])]<[[()()](()[])]([[][]](<><>))>>{{<(<><>)[<>()]>([[]()])}<<[[]()]<[][
    {{{([((([({[{{()()}{<>[]}}({{}{}}([]{}))]{([{}<>])<(<><>){[]<>}}}})({{{(()())[[][]]}{<{}{}>
    {{([[((({(({({<><>}([]{}))([()()]{[]{}})}[[({}{})<(){}>]<<()<>>>]){[[[()()][<>[]]}<[{}()]{{}<>}
    {([<[[<<({[<(<()<>>(()())){<<>[]><()[]>}>[({{}<>})]][[(<()<>>{(){}})[{[]<>}[[]{}])][[(()()){[][]}]<{{}{}}<[
    [<{[((<([[([<<{}()>{{}()}>{(()[])[<>{}]}]<{[<><>]{<>{}}}>)]{[{{{()<>}[{}<>]}<<()>{{}{}}>}]({{<
    [<((<<({[{<{[[<><>](<>{})]{<()()><[]{}>}}<<[{}()]<[][]>><({}<>)>>>{<[[()<>]<{}[]>]<(<>()){<>{}}>>[{(()[])[{
    ([(<<{{<[<(<<[[]{}]({}{})><[()[]]{<><>}>>[[{[]<>}[{}()]][({}{})({}())]>){(<{(){}}[{}[]]>[{[][]}<<
    ([<{<<<[[<{[{({}{})[{}[]]}])[[(({}{}){()<>})<[()[]]<[][]>>]<(<()()>{()()}){(<><>)([]())}>]>]]<<{
    [{((<<{[{[<<<(()[])[[][]]>>><{<{<>[]>{[]{}}>{<<>()>[<><>]}}[{{<>{}}([]())}{({}[])[<><>]}]>][(<({<>()}[[]{}])[
    <(<[[<{(<[(<[([]())]({<>()}({}()))>[({(){}})[[[][]][<>{}]]]){{[[<><>]{{}[]}]<[(){}]<{}()>>}(<(<>{
    {{{([[(<<<{[{(<><>){<>[]}}<<[][]><()<>>>]<[[(){}][<>[]]]{{()<>}[{}()]}>}[{{({}<>)}[[{}{}]{{}[]}]}[([()()]
    {(<[{[{([({[[{<>}]{[<>{}]([][])}]{[(<>[])({}())]<{<><>}({}<>)>}}<[[(<>()){()[]}][<()()>{[]{}}]]<{[[]][[]()]
    <{(({({(<{{<{{()()}<()[]>}{[[]()](<>[])}>}<<({{}()}<[]{}>)[{[]()}]><<<<><>>[<>[]]>>>}([<[{()[]}(()()
    [[[{<({{[[<[{[(){}]<[]<>>}[[<>[]]{()<>}]]({<{}[]>[<>[]]}{({}{})<{}[]>})>{[[{[]{}}{<><>}]{(
    <([<[(([[[[([<[][]>]<([]()){<>()}>){[{[]()}([][])]<{[]<>}({}<>)>}]<[[[[]<>][<>{}]]{{{}()]{<>(
    <({{<<<{<<[[[<()<>>[()[]]]](<[{}<>]{[][]}>[{<>()}<()()>])]><{<[<()<>>[[]()]]<<[][]><()()>>>
    [[{{(([[<{[[(<[][]><<><>>}[{{}()}]]{(<<><>>({}<>))[[[][]]<[]{}>]}]<[{({}<>)[[]]}({()()}[<><>
    ([<[([[<{<((<<{}()>[<>()]>)(<{{}()}>(<[]<>>{()()})))>({<<{(){}}{{}}><[<>{}]<<>{}>>>{([(){}](<>)){{()<>}({
    [{[[<((({[{[<[[]()]<{}[]>>{<{}<>>(<>[])}]<{({}{}){{}[]}}{[[]<>]([][])}>}(<{(<>)[()<>]>>(({{}()})[[{}[]]{[]}
    [{[[({<<{([{{({}())[()[]]}<[<>()]({}{})>}({[{}<>]<<><>>}{{[]<>}{()]})][<([<>()]({}[])){[{}{}](<>[])}>[((()
    {{((<[{{[[(<{({}()){()<>}}[{{}<>)({}{})]>({<(){}>[[]{}]}[[[]()]<{}>]))<<{[[]{}]({}[])}{<()>({}
    <{<({[[({<(<<<[][]>[<>[]]><(()[])>>{([[]<>]({}{}>)})((<[{}][{}<>]>{(()<>)})<<<<>[]>[(){}]>[(<>{})<<>[]>]>)>}
    [[[{[[{<{({<({{}<>}({}<>))>{[({}())]}})[<[[([][])][<{}<>><()<>>]]([[<><>]<[]()>]<({}{})(<><>
    [<({{[(<{(<<((<>)<{}[]>){{<>[]}<{}{}>}>(<(<><>)<{}<>>><{{}()}[{}()]>)>([([[]{}][{}[]])]))}>((({{
    <<{({{(<([[(<[<>()]<<><>>>(<[]()>{{}<>})){{<{}[]>[()()]}<(<>[])<()[]>]}]{({<(){}>{[]()}}[(<>
    (({<[({{[[{{[[()[]]([][])]{(<>[])<(){}>}}<<({}{})([]())><({}[])>>}<<<<{}[]>{[]{}}>(<[][]>[{}{}])>(({()<>
    {[[([<[{[{<[[({}[])<{}[]>]([<>[]]({}{}))][({()[]}(()()))]>{<<({})([]{})>{[[]()](()()]}>[(((){})(()[]))<[[]<>
    ({[(<[(<({<[[[{}()]][<()()>[()[]]]]<{{<>[]}}[[[]{}]([]<>)]>>})<<{[<[()[]](()()}><(()())[<><>]>
    ((<[{([[{(([([<>()][[][]])]))}]])<{(<<{{<<[]{}>({}())>}}>>[{([[{{}()}{(){}}]](((()[])[(){}])<[<><
    {(<{[{<<(<<[<<{}{}>><[[][]}{(){}}>]{{{[]<>}[[]<>]}}>{({<{}<>>({}<>)}<<[]<>>>)[(<{}<>>(<>))<[
    [<({<<({[{[<[([]<>)]{[(){}]({})}>{{((){})}[<[][]>]}]({(<{}<>>(<>())){{[]()}(()())}}(((<>{}){()()}){{[]()}<<>
    [[{{[<<[[[<<[{{}[]}<(){}>][{(){}}<{}[]>]>>(({({}{}}{<>{}}}([<>[]](()[]))))]{[[{((){})<<>()>}{{()[]}{<>()}}]<
    {(([([<({[[{{[<>[]][<>[]]}[([][])[{}()]]}[([()()][{}()])([<>{}])]]][[{[([]{}){[]()}][<(){}
    <{{[{<(((({[{<[]()>({}{})}]}))<[((<([]<>)[{}[]]>{<(){}>[[][]]}))[{<[()()][{}()]>(({}[])<<>[]>)}[((<>()){{}
    [(<[{[[<{[([{{[]()}<()>}(([]())<(){}>)][(({}{})<{}<>>)])(<({{}()}({}))<[()[]]{<>[]}>><(<{}<>><{}<>>)<({}<>
    {([({<<((({[({[][]})<{{}{}}<{}()>>]}<(<<[]()><()<>>>{{[]<>}([][])})(<{[]<>}[[]<>]>)>){([{<[]()>[<>[]]}[{<><
    [{{<<[<<<<{<({[]}[()[]]){{{}<>}[(){}]}>({([]())({}[])>)}><[[{[()<>]({}{})}<<<>{}>{()[]}>]{{[[][]]}(<<>()><
    (({({[{({[{[{([][])[[][]]}]{{{[]()}({}[])}({<>[]}(<>))}}[<<([]<>)>(<{}{}>{()})>[{[<><>][<>{}]}]]]}([{
    (({{<[{[([({([{}{}][{}<>])<<{}{}><<>()>>})]([((<[]()>[{}()])<<{}<>>((){})>)]<{[[{}<>]<[][]>]<(()[]
    {<[({<[[<[(<<({}[])[[]()]>([<>{}]{{}<>})>[<<{}[]>{<>()}><[<>{}]({}[])>])]{{{({{}{}}<[]()>)
    {<(({<[({<<[[[()[]]<{}<>>]]>><[{<{<><>}(<><>)>[[()[]]{<><>}]}[[{<><>}{{}<>}]({{}{}}[[][]])]]<<[{{}{}}<<>[]>]
    [<{({{(({([{(<{}[]>(<>{}))<[[]{}](()[])>}<{(<>{})(<>{})}>])<<<<({}<>){<>{}}>[(()()>(()())]>
    ({((({[(<{{({({}())[[]<>]}([<>[]]{{}()}))<({{}()}<{}{}>)[{[]{}}({}[])]>}[([{{}<>}<{}>])[{{()[]}{{}()}}[([]{
    [<[{<{([<({<[[{}<>]{[][]}]{<<>{}><<><>>}>({[[]{}]<{}<>>}{{{}<>}(()[])})}){{{[<[]()><[][]>]
    <<{<{[[{([{<[<{}[]>{[]<>}]<<{}{}>[{}[]]>>}([([{}{}]{<><>})[{<>{}})])]){{([[<{}[]>({}[])][[<><>]
    ([[(<([[[<[((([]{}){[]<>}))<{<[][]>[[]()]}[(()<>)<[]{}>]>]{[([[][]][()[]]){{(){}}[{}<>]}]}><
    <[{{<{<({{([[[[]{}]<{}()>><([]()){[]{}}>]<{<()[]>([]())}>)}<<{{((){}){[][]}}(({}<>)(()()))}([{[
    ({{({[[{<({[({<>{}}[<>()])(([][]){{}{}])][({{}<>}(()[]))[<[]()><[]{}>]]}[{(<()[]><[]()>)[<{}()>{()[]}]}
    <<<{<{[([[[[(<()[]>){<[]()><[]()>}]<<([])<[]<>>><[[]<>][<>[]]>>]<<[[()()](<><>)]({()()}[<>[]])>([<[]
    ((([{([({({<(<{}()>[()<>])<[{}<>]<{}[]>>>][{<[[][]]{{}()}>[({}()){[]<>}]}([{{}{}}[[]()]])])<[(({<>()}
    ([<<[(<{<<[<[{()[]}{()[]}](({}[]){{}[]})>]{([{()[]}])({{<>()}(()())})}>((({{()()}(()<>)}][[(<>()){()}
    ({[{[((<[<{<([[][]]{{}()})[{<>()}(<>{})]>{{{{}}}{{()}({}[])}}}>]<(<{<(<>())(()())>}>[<{[{}<>]{{
    {({[<{<[[[[<({<>{}}{()[]}){<[]()><[]()>}>([(<>())[[]()]](({}{})[()<>]))]]({([[<>{}]<{}[]>](<()()><()<>>))
    ([<[<{<<<<((({<>}[<>{}])<({}())<()<>>>)[[[[]()][{}{}]]<(()<>)[<>]>]){{[({}())][([][])<()[]>]}{
    [{[({{<[{[<<[[<>()]]<([]())>><<<[][]>>{[()<>]{{}}}>>]}]{<{{{{[<>{}]({}[])}<{{}}{<>{}}>}{<({}){<>
    {<<{{({([{[([{[]<>}{<>[]}](<()[]>))[([{}]<()<>>)<<<>[]>[()<>]>]]}{[{<[()[]][{}{}]>{[[]()][{}[]]}}({[[]{
    ((<(<{{<([{[{{()[]}{<><>}}{{<>}({}{})})[([(){}][[][]])[<()[]><(){}>]]}<([(<>()){[][]}][([]())([]())])[
    <<{[{{<{<[[[<<()<>>[()[]]>([()]{{}[]})]](<[(()<>)[()[]]]>{<[{}{}]>[<<><>><<><>>]})][{((<{}{}>[()
    <<<[[<[[([{[(<()><[]{}>)[(()[])[[]{}]]]{[{{}<>}[{}<>]]}}[(<<<>()><()[]>>[({}())<(){}>])[[[[][]][<
    [[<(({[(([{{<([][])[[][]]>[{{}{}}{<>[]}]}<[(<><>)](<[][]>[<>{}])>}]{{{([(){}]([]))<[{}<>](())>}([[(
    [<{[([<{({([((()>[{}[]])[(<><>){[][]}]])([{([]<>){[][]}}<(()[]){[]()}>]<((<>{}){[][]})({{}()}<()[
    ((((<<<({([<{[{}()]{[]{}}}{({}[]){(){}}}>[[{()[]}[<>()]]<(()<>){(){}}>]]{[<(()())[{}[]]>(<<>()>({}
    (<({((((<{{{[{{}{}}[(){}]][{<>{}}{(){}}]}([[{}[]]{<><>}]<[[]{}]<[][]>>)}({[[{}<>]<(){}>]}<{{<>[]}}<<<>[]>
    {(<{(<{({(([{{()()}}][(({}{})<{}>)])<<(<()<>>{{}<>})(((){})[[]{}])><[[<>{})[<><>]][{()()}]>
    <{[(<[[{(<({[<{}()>{{}{}}]{(()){[]{}}}}[{{[]<>}[{}{}]}])({({[][]}{[]()})})>(<{{(()[])<<>>>[<<>[]><[]<
    ([<[<[[{<[<(([<>{}]){[(){}]<()()>})<{([]{}}<{}<>>}{<{}{}><[]()>}>>(<<{<><>}(<>())>({<>}[{}{}])>(<(<><>)
    ([{[[(<[(([{[{<>[]}{<>()}]<[(){}](<>{})>]<<<<>[]>>{(<><>)<[]{}>}>])){{{{<([]<>)([]{})><{{}{
    [<{({{(({<[([[()<>]{[][]}]({<>[]}(()[])))](<<({}())([][])>[{()<>}(()())]><{[<>{}]<<>()>}[[{}()]{<><>}]>)>{
    {({{{{[{{[<{{<[][]>([])}<[[]{}][{}()]>}>]{{[[<<>[]>[[][]>]<<{}<>>(()<>)>]{[[<>{}]{{}[]}]}}<[[[<><>]<<
    <({{({(({{<{{([]{}){<><>}}<(<>())({}{}]>}[{((){})(<>())}]>(({<[]()>([]{})}({{}{}}<<>()>)))}[[([<{}<>>
    [[<{<{<((<<({(<>())(<>())}{{(){}}[{}()]})<(<{}<>>{(){}})>>{{({[][]}{{}[]})<<{}<>>(()<>)>}<<<<>()>>{({}{}){()
    {[(<<<{(<{<<({<>{}}{()[]}>({<>[]}({}()))>>}>)<{(<(<({}[]){()[]}>)>((({()[]}[[][]]){<[][]><<>()>})[(([]<>)<
    <[<[{<[{[[<([<{}()>[<>]]{[[][]]<{}()>}}>({{{<>[]}{()[]}}{{()}<<><>>}}<<([])([][])>{[{}<>]((
    {[<<[[(<<{[<[[[]]({}())]([{}()][[]<>])>]}<({{(()[])<[][]>}{({})<()<>>}})([((()[])<[]<>>)<{(){}}([]())
    <{{<[[[(((<[{({}()){()()}}(<{}()>{()<>})]{{{()()}}{[[]{}]({}())}}>))<{<(((()<>)[{}[]])){[<[]<>>{{}()
    <([((<<(((({{[{}<>]<[]<>>}(<[]{}><[]{}>)}[{{<>[]}}{(<>{}){[]<>}}])<<{(()())<<>{}>}[[{}[]][{}()]]>[<[[]()
    {({{({[[({[<[<<><>)<{}{}>][<(){}>{[]{}}]>({(<>{})(<>())}<({})({})>)]})]<({[[({[]<>}{()()}){({}()
    ((([[(<(<[([({{}()})[{{}()}({}{})]]{({[]()}{{}()})(<()[]><<>[]>)}){{([{}()])}}]<[(<(<><>)[()[]}>[{{}<>}])]>>[
    {(([(<[[[[<<([(){}][<>[]]){({}())[[]{}]}>>[[<{()[]}{(){}}>(<{}{}><{}{}>)]<([()[]]<{}>)(<()[]>{
    {({([(<{<[[<<[<><>]<<><>>>>[<<{}<>>[{}<>]>{[[]{}][{}<>]}]]][{{<[{}[]]({})><[()()]>}}<[<{[]<>}[[]()]>]{[
    (((<{([<[(<[{([][])<[][]>}({{}<>}[{}{}])]>[[({[]<>}{<>{}})]})[{({(()[])([][])}{<()()>[[][]
    <(<{{<([<(<{<{{}}{<>{}}>}([([]{}){(){}>]{<()<>>([])})>)<<({<[]<>>})({[()[]]}<[(){}]{{}()}>)>{[<<[][]>>({[]{
    ({{(<(([[{((<<()[]><{}<>>>])}][<({<[{}[]][{}{}]><(()())([]())>})>{<(<{[]{}}{{}<>}>{{[]<>}{<><>}})>}]]{<[{[[
    {<[<([(((<[{[(())]}[(<{}()>)([[]][{}])]]{({<[]{}><()[]>}{{[]()}<{}<>>})}>){(({{<(){}>{<>[]}}(<(){}>(
    ([[{<{{{({{<[<[][]><()()>>><<[<>()]>>}{[[(())]<{[]<>}<()<>>>]}})(<({[([]<>)<<>[]>]({<>()}[
    {<[<<[((<<{<{([]<>)(<><>)}([()<>][{}[]])>}<<{{[]()}(<>{})}([<><>]({}[]))>{<[()<>]<{}()>>{<()(
    {<{(<[[[<[{<[({}())<()<>>]>[{([]{})([]<>)}[<[][]>]>}][<([[()<>]{[][]}]){<[[]()](()())>({()}(()()))}>({<[()<
    [{({<<<({{<[(({}[]){{}()})[{[]{}}{<><>}]]<{<[][]>(<>())}([<>{}])>>}[(<{{<>}([][])}>{{[[]()][[][]]}{<<>()><
    <<([{{[(<[([<{[]()}<<><>>><(()())<()[]>>][{<[]()><{}()>}{<<><>>[()<>]}])(<<<<>{}][{}[]]>[{<>}({}
    ((<<<<[{<[[<[{()()}<[][]>]{(()<>)}><{[[]{}]<{}{}>}>]<<{{[]<>}([])}{({}())([]{})]><[(<>())(<>{})]>>]><([<(([]
    {[[<(<[({[[[{{<>()}<()()>}]]]}[({(<[[][]]>(<{}<>>))}[<{<[]{}>(()<>)}{<{}{}>[()<>]}>])(<{([[]<>]){
    {{<<{([<{[[[(<{}{}>[[]<>])({<><>}{{}[]})]]][([([()[]])[(()<>)<[]{}>]]<{{()<>}{[]()}}<<[]{}>{
    <(([[<(({{(<{{()<>}[<>()]}[({}())[[][]]]>{{[{}<>]((){})][<<>{}><[]{}>]})<<({{}()}<<>{}>){(<>())[<>{}]}>(
    (<[(<<(((([<[<{}[]>][[()()]<<>()>]><[<{}{}>{()<>}](<()()])>][{{[{}<>]{<>()}}[<()()><{}>]}<(<{}{
    ({{({[(<[{[<[((){})({}{})]([<>[]][[]()])>](<(<(){}><()()>)({<>{}}<{}()>)><{{<>()}(())}<{()()}<[]()>>
    {<([(<<{([[[[(()<>)(()())]][[([]{})({}())]<[[]<>]{()[]}>)]([[<(){}>{<>{}}]((()())[()()])])]
    (<<(((<[[{[{<[()<>]{<>{}}>([[]()][()()])}]{([<[]<>>{<>[]}]<<[][]>[{}()]>){<{[][]}[<>{}]><[<>[]]({}{}
    <([[[(<[([{((<<>()>{()[]}){(<>())([])})[{<{}[]>([][])}[({}[])[<>()]]]}[(<<<>{}><()<>>><<<>[]>{(
    [[{<[[(<<<(([(<><>)([][])](([]{}){[]{}}))[<[[]{}]>([[]()]{[][]})])>{{{[<()[]>[[]{}]][{()<>}[<>[]]]}}
    ([(<{<<(<{{{[[<>[]]<(){}>]([()[]][()[]])}{((<>()))}}{<[<{}<>>(<><>)](([][])<<>()>)}}}(<<[<{}[]
    <[{{({{<[<[{(<<>[]>(<>()))<([]<>)[{}<>]>}]>{<<{<[]{}>(<>())}>([<(){}><(){}>]{[<>()]([]())})>}]>}})}}{(((
    [<(((<{<<[(<{(<>[])}>){(<<{}<>>([]<>)>{<{}()>}}[[<{}{}>{[][]}](<<>[]>{{}[]})]}]><<([<[(){}]<()>><[(){}]
    ({[[(<[{(<((<[()[]]{[]<>}>){<(<>){()<>}>})(({<(){}>[{}[]]})[[(()[]){[]<>})<{[]()}>])>)<<<(<({}())(<>[])
    [{([<<<[{{([<<{}{}>>[{{}[]]]])}<<[<{{}}{<><>}>(({}{})[<>[]])]({[<><>]([][])}{(()<>)<<><>>})
    [[<(<<[{([[[[<[]{}><[]()>]][{[[][]]<()<>>}]]]{{{(<[]{}>(()<>))<(<>[])<<><>>>}]({{(()[]){{}()}}
    ({<<<{[<[[[{([{}<>]{<>()})(<<><>>)}(<(<>[])<{}>))][({<{}[]>[[][]]}(([]())(()[])))<<[[]()]{<><>}>>
    [{<[[{{[<<([([<><>]([]<>))]({[()[]][{}{}]}{{()()}[[]<>]})){(<(()[])<[]()>><[[]()]<()<>>>)(<<()(
    {<({((<([<(({{[]<>}[{}<>]}[<()[]><[]{}>]){<{[][]}{<><>]>})(({({}())[()()]}{[{}()][[]<>]}))>])<(<{(<{
    """
