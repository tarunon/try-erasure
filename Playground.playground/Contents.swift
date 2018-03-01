//: Playground - noun: a place where people can play

import TryErasure

func getBark<A>(_ animal: A) -> String where A: AnimalProtocol {
    return animal.bark()
}

extension Array where Element: AnimalProtocol {
    func getBarks() -> [String] {
        return map { $0.bark() }
    }
}

class Cat: AnimalProtocol {
    func bark() -> String {
        return "mew"
    }
    
    func walk() {
        fatalError() // TBD
    }
    
    func eat(_ target: Any) {
        fatalError() // TBD
    }
    
    func sleep() {
        fatalError() // TBD
    }
}

ExistentialCannotCallGenerics: do {
    let cat: AnimalProtocol = Cat()
    // getBark(cat) // 🙅
    // [cat, cat, cat].getBarks() // 🙅
}

ErasureCanCallGenerics: do {
    let cat = ProxiedBoxErasure.AnimalErasure(Cat())
    getBark(cat) // 🙆
    [cat, cat, cat].getBarks() // 🙆
}

AnyEquatableChallenge: do {
    AnyEquatable(1) == AnyEquatable("1")
    AnyEquatable("1") == AnyEquatable("1")
}

