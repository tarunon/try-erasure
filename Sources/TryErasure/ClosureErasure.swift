//
//  ClosureErasure.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// TypeErasure implements using closure.
/// ## Pros
/// - Conform to original Protocol.
/// - Method invocation is Closure.
/// ## Cons
/// - Memory size.
/// - Heavy init.
public enum ClosureErasure: NameSpace {
    /// Type erasure for Animal based Closure.
    public struct AnimalErasure: AnimalProtocol {
        internal let _bark: () -> String
        internal let _eat: (Any) -> ()
        internal let _walk: () -> ()
        internal let _sleep: () -> ()

        public init<Animal>(_ animal: Animal) where Animal: AnimalProtocol {
            self._bark = animal.bark
            self._eat = animal.eat
            self._walk = animal.walk
            self._sleep = animal.sleep
        }

        public func bark() -> String {
            return _bark()
        }

        public func eat(_ targtet: Any) {
            _eat(targtet)
        }

        public func walk() {
            _walk()
        }

        public func sleep() {
            _sleep()
        }
    }

    /// Type erasure for Farm based Closure.
    public struct FarmErasure<Animal>: FarmProtocol where Animal: AnimalProtocol {
        internal let _get: () -> Animal

        public init<Farm>(_ farm: Farm) where Farm: FarmProtocol, Farm.Animal == Animal {
            self._get = farm.get
        }

        public func get() -> Animal {
            return _get()
        }
    }
}
