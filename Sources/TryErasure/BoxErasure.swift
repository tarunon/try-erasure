//
//  BoxErasure.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

/// TypeErasure implements using class inheritance.
/// ## Pros
/// - Conform to original Protocol.
/// - Mem size.
/// ## Cons
/// - Method invocation overhead.
/// - 2 times reference table (v-table, witness-table).
public enum BoxErasure: NameSpace {
    /// Type erasure for Animal based Box.
    public struct AnimalErasure: AnimalProtocol {
        internal class AnimalBoxBase: AnimalProtocol {
            func bark() -> String {
                fatalError()
            }

            func eat(_ target: Any) {
                fatalError()
            }

            func walk() {
                fatalError()
            }

            func sleep() {
                fatalError()
            }
        }

        internal class AnimalBox<Animal>: AnimalBoxBase where Animal: AnimalProtocol {
            let internalAnimal: Animal
            init(_ animal: Animal) {
                self.internalAnimal = animal
            }

            override func bark() -> String {
                return internalAnimal.bark()
            }

            override func eat(_ target: Any) {
                internalAnimal.eat(target)
            }

            override func walk() {
                internalAnimal.walk()
            }

            override func sleep() {
                internalAnimal.sleep()
            }
        }

        internal let box: AnimalBoxBase

        public init<Animal>(_ animal: Animal) where Animal: AnimalProtocol {
            box = AnimalBox.init(animal)
        }

        public func bark() -> String {
            return box.bark()
        }

        public func eat(_ target: Any) {
            box.eat(target)
        }

        public func walk() {
            box.walk()
        }

        public func sleep() {
            box.sleep()
        }
    }

    /// Type erasure for Farm based Box.
    public struct FarmErasure<Animal: AnimalProtocol>: FarmProtocol {
        internal class FarmBoxBase: FarmProtocol {
            func get() -> Animal {
                fatalError()
            }
        }

        internal class FarmBox<Farm>: FarmBoxBase where Farm: FarmProtocol, Farm.Animal == Animal {
            let internalFarm: Farm
            init(_ farm: Farm) {
                self.internalFarm = farm
            }

            override func get() -> Animal {
                return internalFarm.get()
            }
        }

        internal let box: FarmBoxBase

        public init<Farm>(_ farm: Farm) where Farm: FarmProtocol, Farm.Animal == Animal {
            self.box = FarmBox(farm)
        }

        public func get() -> Animal {
            return box.get()
        }
    }
}
