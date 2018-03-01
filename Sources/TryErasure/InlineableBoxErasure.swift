//
//  InlineableBoxErasure.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// Inlined BoxErasure.
/// Get lighter method invocation overhead.
public enum InlineableBoxErasure: NameSpace {
    /// Type erasure for Animal based Box and inlined.
    public struct AnimalErasure: AnimalProtocol {
        @_versioned
        internal class AnimalBoxBase: AnimalProtocol {
            @_versioned
            func bark() -> String {
                fatalError()
            }

            @_versioned
            func eat(_ target: Any) {
                fatalError()
            }

            @_versioned
            func walk() {
                fatalError()
            }

            @_versioned
            func sleep() {
                fatalError()
            }
        }

        @_versioned
        internal class AnimalBox<Animal>: AnimalBoxBase where Animal: AnimalProtocol {
            let internalAnimal: Animal
            init(_ animal: Animal) {
                self.internalAnimal = animal
            }

            @_versioned
            override func bark() -> String {
                return internalAnimal.bark()
            }

            @_versioned
            override func eat(_ target: Any) {
                internalAnimal.eat(target)
            }

            @_versioned
            override func walk() {
                internalAnimal.walk()
            }

            @_versioned
            override func sleep() {
                internalAnimal.sleep()
            }
        }

        @_versioned
        internal let box: AnimalBoxBase

        public init<Animal>(_ animal: Animal) where Animal: AnimalProtocol {
            box = AnimalBox.init(animal)
        }

        @_inlineable
        public func bark() -> String {
            return box.bark()
        }

        @_inlineable
        public func eat(_ target: Any) {
            box.eat(target)
        }

        @_inlineable
        public func walk() {
            box.walk()
        }

        @_inlineable
        public func sleep() {
            box.sleep()
        }
    }

    /// Type erasure for Farm based Box and inlined.
    public struct FarmErasure<Animal: AnimalProtocol>: FarmProtocol {
        @_versioned
        internal class FarmBoxBase: FarmProtocol {
            @_versioned
            func get() -> Animal {
                fatalError()
            }
        }

        @_versioned
        internal class FarmBox<Farm>: FarmBoxBase where Farm: FarmProtocol, Farm.Animal == Animal {
            let internalFarm: Farm
            init(_ farm: Farm) {
                self.internalFarm = farm
            }

            @_versioned
            override func get() -> Animal {
                return internalFarm.get()
            }
        }

        @_versioned
        internal let box: FarmBoxBase

        public init<Farm>(_ farm: Farm) where Farm: FarmProtocol, Farm.Animal == Animal {
            self.box = FarmBox(farm)
        }

        @_inlineable
        public func get() -> Animal {
            return box.get()
        }
    }
}
