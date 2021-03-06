import Foundation

@resultBuilder
public struct ConstraintBuilder<T, E: Error> {
    
    public static func buildExpression<C: Constraint>(_ expression: C) -> ConstraintContainer<T, E> where C.InputType == T, C.ErrorType == E {
        return ConstraintContainer(expression)
    }
    
    public static func buildEither(first component: ConstraintContainer<T, E>) -> ConstraintContainer<T, E> {
        return component
    }
    
    public static func buildEither(second component: ConstraintContainer<T, E>) -> ConstraintContainer<T, E> {
        return component
    }
    
    public static func buildOptional(_ component: ConstraintContainer<T, E>?) -> ConstraintContainer<T, E> {
        return component ?? ConstraintContainer()
    }
    
    public static func buildLimitedAvailability(_ component: ConstraintContainer<T, E>) -> ConstraintContainer<T, E> {
        return component
    }
    
    public static func buildBlock(_ components: ConstraintContainer<T, E>...) -> ConstraintContainer<T, E> {
        return ConstraintContainer.flatMap(containers: components)
    }
    
    public static func buildArray(_ components: [ConstraintContainer<T, E>]) -> ConstraintContainer<T, E> {
        return ConstraintContainer.flatMap(containers: components)
    }
    
    public static func buildFinalResult(_ component: ConstraintContainer<T, E>) -> [AnyConstraint<T, E>] {
        return component.constraints
    }
}

extension ConstraintBuilder {
    
    public struct ConstraintContainer<T, E: Error> {
        
        private(set) var constraints = [AnyConstraint<T, E>]()
        
        init(){ }
        
        init<C: Constraint>(_ constraints: [C]) where C.InputType == T, C.ErrorType == E {
            self.constraints = constraints.map { $0.erase() }
        }
        
        init<C: Constraint>(_ constraints: C...) where C.InputType == T, C.ErrorType == E {
            self.constraints = constraints.map { $0.erase() }
        }
        
        static func flatMap(containers:  [ConstraintContainer] = []) -> ConstraintContainer {
            let constraints = containers.reduce([]) { $0 + $1.constraints }
            return ConstraintContainer(constraints)
        }
    }
}
