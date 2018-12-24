func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { (a: A) -> (B) -> C in { (b: B) -> C in function(a, b) } }
}

func map<T, U>(_ f: @escaping (T) -> U) -> ([T]) -> [U] {
    return { values in
        return values.map(f)
    }
}

func first<T, U>(_ value: (T, U)) -> T {
    return value.0
}

func second<T, U>(_ value: (T, U)) -> U {
    return value.1
}

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : ForwardApplication

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}
