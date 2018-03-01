//
//  InlineableClosureErasure.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// Inlined ClosureErasure.
/// Get lighter method invocation overhead.
public enum InlineableClosureErasure: NameSpace {
    /// Type erasure for Animal based Closure and inlined.
    public struct AnimalErasure: AnimalProtocol {
        @_versioned
        internal let _bark: () -> String
        @_versioned
        internal let _eat: (Any) -> ()
        @_versioned
        internal let _walk: () -> ()
        @_versioned
        internal let _sleep: () -> ()


        public init<Animal>(_ animal: Animal) where Animal: AnimalProtocol {
            self._bark = animal.bark
            self._eat = animal.eat
            self._walk = animal.walk
            self._sleep = animal.sleep
        }

        @_inlineable
        public func bark() -> String {
            return _bark()
        }

        @_inlineable
        public func eat(_ target: Any) {
            _eat(target)
        }

        @_inlineable
        public func walk() {
            _walk()
        }

        @_inlineable
        public func sleep() {
            _sleep()
        }
    }

    /// Type erasure for Farm based Closure and inlined.
    public struct FarmErasure<Animal>: FarmProtocol where Animal: AnimalProtocol {
        @_versioned
        internal let _get: () -> Animal

        public init<Farm>(_ farm: Farm) where Farm: FarmProtocol, Farm.Animal == Animal {
            self._get = farm.get
        }

        @_inlineable
        public func get() -> Animal {
            return _get()
        }
    }
}
