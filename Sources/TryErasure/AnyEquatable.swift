//
//  AnyEquatable.swift
//  TryErasurePackageDescription
//
//  Created by tarunon on 2018/03/01.
//

/// Challenge making TypeErasure of protocol that self referenced.
public struct AnyEquatable: Equatable {
    @_versioned
    internal class Base {
        @_versioned
        var value: Any { fatalError() }
        
        @_versioned
        internal func isEqual(to other: Base) -> Bool {
            fatalError()
        }
    }
    
    @_versioned
    internal class Box<E>: Base where E: Equatable {
        @_versioned
        var _value: E
        @_versioned
        override var value: Any { return _value }
        @_versioned
        internal override func isEqual(to other: Base) -> Bool {
            guard let value = other.value as? E else { return false }
            return _value == value
        }
        init(_ value: E) {
            self._value = value
        }
    }
    
    @_versioned
    internal let box: Base
    
    public init<E>(_ value: E) where E: Equatable {
        self.box = Box(value)
    }
    
    @_inlineable
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.box.isEqual(to: rhs.box)
    }
}
