//
//  Protocols.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// Workaround protocol NameSpace.
/// Plz use it with `no case enum`.
public protocol NameSpace {}

public extension NameSpace {
    @available(*, unavailable)
    public init() { fatalError() }
}

/// 4 func, 0 assoctype Protocol sample
public protocol AnimalProtocol {
    func bark() -> String
    func eat(_ targtet: Any)
    func walk()
    func sleep()
}

/// 1 func, 1 assoctype Protocol sample
public protocol FarmProtocol {
    associatedtype Animal: AnimalProtocol
    func get() -> Animal
}
