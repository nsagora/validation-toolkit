import Foundation

/**
 The `RangePredicate` struct is used to evaluate whether a given input is inside a given range.
 
 ```swift
 let drinkingAgeLimit = RangePredicate(min: 21)
 let isAllowed = drinkingAgeLimit.evaluate(with: 18)
 ```
 */
public struct RangePredicate<T: Comparable>: Predicate {
    
    public typealias InputType = T
    
    private let min: T?
    private let max: T?
    
    /**
     Returns a new `RangePredicate` instance.
     
     ```swift
     let drinkingAgeLimit = RangePredicate(min: 21)
     let isAllowed = drinkingAgeLimit.evaluate(with: 18)
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public init(min: T? = nil, max: T? = nil) {
        self.min = min
        self.max = max
    }
    
    /**
     Returns a new `RangePredicate` instance.
     
     ```swift
     let predicate = RangePredicate(21...90)
     let isAllowed = predicate.evaluate(with: 25)
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public init(_ range: ClosedRange<T>) {
        self.init(min: range.lowerBound, max: range.upperBound)
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is inside the given range bounds.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is between the range bounds, otherwise `false`.
     */
    public func evaluate(with input: T) -> Bool {
        
        if let min = min, let max = max {
            return input >= min && input <= max
        }
        
        if let min = min {
            return input >= min
        }
        
        if let max = max {
            return input <= max
        }
        
        return true
    }
}

extension RangePredicate where T: Strideable, T.Stride: SignedInteger {
    
    /**
     Returns a new `RangePredicate` instance.
     
     ```swift
     let predicate = RangePredicate(21..<91)
     let isAllowed = predicate.evaluate(with: 25)
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public init(_ range: Range<T>) {
        self.init(ClosedRange<T>(range))
    }
}
