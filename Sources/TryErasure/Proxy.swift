//
//  Proxy.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// Proxy of Animal. There are default implementation of calling internal object.
public protocol AnimalProxy: AnimalProtocol {
    associatedtype Animal: AnimalProtocol

    var internalAnimal: Animal { get }
}

public extension AnimalProxy {
    @inline(__always)
    public func bark() -> String {
        return internalAnimal.bark()
    }

    @inline(__always)
    public func eat(_ targtet: Any) {
        internalAnimal.eat(targtet)
    }

    @inline(__always)
    public func walk() {
        internalAnimal.walk()
    }

    @inline(__always)
    public func sleep() {
        internalAnimal.sleep()
    }
}

/// Proxy of Farm. There are default implementation of calling internal object.
public protocol FarmProxy: FarmProtocol {
    associatedtype Farm: FarmProtocol where Animal == Farm.Animal

    var internalFarm: Farm { get }
}

public extension FarmProxy {
    @inline(__always)
    public func get() -> Animal {
        return internalFarm.get()
    }
}
