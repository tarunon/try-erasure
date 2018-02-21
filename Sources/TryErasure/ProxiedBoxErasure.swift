//
//  ProxiedBoxErasure.swift
//  TryErasure
//
//  Created by tarunon on 2018/02/19.
//  Copyright © 2018 tarunon. All rights reserved.
//

import Foundation

/// TypeErasure implements using Box and Proxy pattern.
/// ## Pros
/// - No need each func implementation calling Box methods.
/// ## Cons
/// - BoxBase class should be public.
public enum ProxiedBoxErasure: NameSpace {
    /// Type erasure for Animal based Proxy.
    public struct AnimalErasure: AnimalProxy {
        public class AnimalBoxBase: AnimalProtocol {
            public func bark() -> String {
                fatalError()
            }

            public func eat(_ targtet: Any) {
                fatalError()
            }

            public func walk() {
                fatalError()
            }

            public func sleep() {
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
        }

        public var internalAnimal: AnimalBoxBase

        public init<Animal>(_ animal: Animal) where Animal: AnimalProtocol {
            self.internalAnimal = AnimalBox.init(animal)
        }
    }

    /// Type erasure for Farm based Proxy.
    public struct FarmErasure<Animal: AnimalProtocol>: FarmProxy {
        public class FarmBoxBase: FarmProtocol {
            public func get() -> Animal {
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

        public var internalFarm: FarmBoxBase

        public init<Farm>(_ farm: Farm) where Farm: FarmProtocol, Farm.Animal == Animal {
            self.internalFarm = FarmBox(farm)
        }
    }
}
