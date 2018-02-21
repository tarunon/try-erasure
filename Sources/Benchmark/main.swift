import Foundation
import TryErasure

struct PrintTable: CustomStringConvertible {
    let title: String
    let textLength: Int
    let header: [String]
    let rows: [TablePrintable]

    private func normalize(_ arg: String) -> String {
        if arg.count > textLength { return arg }
        return ([arg] + Array(repeating: " ", count: textLength - arg.count)).joined()
    }

    var description: String {
        return """
        ***** [\(title)] *****
        \(header.map { normalize($0) }.joined(separator: "\t"))
        \(rows.map { $0.row.map { normalize($0) }.joined(separator: "\t") }.joined(separator: "\n") )
        \n
        """
    }
}

protocol TablePrintable {
    var row: [String] { get }
}

extension Array: TablePrintable where Element == String {
    var row: [String] { return self }
}

struct ClockMeasure<T>: TablePrintable {
    let label: String
    let value: T
    let initTime: clock_t
    let methodTime: clock_t

    init<U>(_ label: String, `init`: () -> T, `method`: (T) -> U) {
        self.label = label
        let start = clock()
        var value: T!
        for _ in 0..<100_000 { value = `init`() }
        self.value = value
        self.initTime = clock() - start
        let start2 = clock()
        for _ in 0..<100_000 { _ = `method`(value) }
        self.methodTime = clock() - start2
    }

    var row: [String] {
        return [
            label,
            "\(initTime)",
            "\(MemoryLayout.size(ofValue: value))",
            "\(methodTime)"
        ]
    }
}

struct Cat: AnimalProtocol {
    func eat(_ targtet: Any) {
        fatalError() // TBD
    }

    func walk() {
        fatalError() // TBD
    }

    func sleep() {
        fatalError() // TBD
    }

    func bark() -> String {
        return "mew"
    }
}

struct CardboardHouse: FarmProtocol {
    let cat: Cat
    func get() -> Cat {
        return cat
    }
}

enum Execute: NameSpace {
    static func random<A, B, C, D, E, F>(
        _ a: @autoclosure @escaping () -> A,
        _ b: @autoclosure @escaping () -> B,
        _ c: @autoclosure @escaping () -> C,
        _ d: @autoclosure @escaping () -> D,
        _ e: @autoclosure @escaping () -> E,
        _ f: @autoclosure @escaping () -> F)
        -> (A, B, C, D, E, F) {
            var x = (a: A?.none, b: B?.none, c: C?.none, d: D?.none, e: E?.none, f: F?.none)
            [
                { x.a = a() },
                { x.b = b() },
                { x.c = c() },
                { x.d = d() },
                { x.e = e() },
                { x.f = f() }
                ]
                .sorted { _,_  in arc4random() % 2 == 0 }
                .forEach { $0() }
            return (
                x.a!,
                x.b!,
                x.c!,
                x.d!,
                x.e!,
                x.f!
            )
    }

    static func benchmark(_ f: () -> ()) {
        while true {
            f()
            Thread.sleep(forTimeInterval: 1)
        }
    }
}

Execute.benchmark {
    let cat = Cat()
    let cardboardHouse = CardboardHouse(cat: cat)

    let (animal_0, animal_1, animal_2, animal_3, animal_4, animal_5)
        = Execute.random(
            ClockMeasure(
                "Existential",
                init: { cat as AnimalProtocol },
                method: { $0.bark() }
            ),
            ClockMeasure(
                "Closure",
                init: { ClosureErasure.AnimalErasure(cat) },
                method: { $0.bark() }
            ),
            ClockMeasure(
                "InlineClosure",
                init: { InlineableClosureErasure.AnimalErasure(cat) },
                method: { $0.bark() }
            ),
            ClockMeasure(
                "Box",
                init: { BoxErasure.AnimalErasure(cat) },
                method: { $0.bark() }
            ),
            ClockMeasure(
                "InlineBox",
                init: { InlineableBoxErasure.AnimalErasure(cat) },
                method: { $0.bark() }
            ),
            ClockMeasure(
                "ProxyBox",
                init: { ProxiedBoxErasure.AnimalErasure(cat) },
                method: { $0.bark() }
            )
    )

    print(
        PrintTable(
            title: "Animal(4 function, 0 assoctype)",
            textLength: 25,
            header: ["＼", "init clock(x100_000)", "mem size", "method clock(x100_000)"],
            rows: [animal_0, animal_1, animal_2, animal_3, animal_4, animal_5]
        )
    )

    let (farm_0, farm_1, farm_2, farm_3, farm_4, farm_5)
        = Execute.random(
            /* ClockMeasure(
             "Existential",
             init: { cardboardHouse as FarmProtocol },
             method: { /* $0.get() */ }
             ), */ // Cannot make existential with associatedtype in Swift 4
            ["Existential", "---", "---", "---"],
            ClockMeasure(
                "Closure",
                init: { ClosureErasure.FarmErasure(cardboardHouse) },
                method: { $0.get() }
            ),
            ClockMeasure(
                "InlineClosure",
                init: { InlineableClosureErasure.FarmErasure(cardboardHouse) },
                method: { $0.get() }
            ),
            ClockMeasure(
                "Box",
                init: { BoxErasure.FarmErasure(cardboardHouse) },
                method: { $0.get() }
            ),
            ClockMeasure(
                "InlineBox",
                init: { InlineableBoxErasure.FarmErasure(cardboardHouse) },
                method: { $0.get() }
            ),
            ClockMeasure(
                "ProxyBox",
                init: { ProxiedBoxErasure.FarmErasure(cardboardHouse) },
                method: { $0.get() }
            )
    )

    print(
        PrintTable(
            title: "Farm(1 function, 1 assoctype)",
            textLength: 25,
            header: ["＼", "init clock(x100_000)", "mem size", "method clock(x100_000)"],
            rows: [farm_0, farm_1, farm_2, farm_3, farm_4, farm_5]
        )
    )

    assert(
        Array(repeating: "mew", count: 5) == [farm_1.value.get().bark(), farm_2.value.get().bark(), farm_3.value.get().bark(), farm_4.value.get().bark(), farm_5.value.get().bark()]
    )
} 