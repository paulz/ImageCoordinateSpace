import Quick

public func describe(_ type: Any, flags: FilterFlags = [:], closure: () -> Void) {
    describe(String(describing: type), flags: flags, closure: closure)
}

public func context(_ selectorOrFunction: Any, flags: FilterFlags = [:], closure: () -> Void) {
    context(String(describing: selectorOrFunction), flags: flags, closure: closure)
}

public func fcontext(_ selectorOrFunction: Any, flags: FilterFlags = [:], closure: () -> Void) {
    fcontext(String(describing: selectorOrFunction), flags: flags, closure: closure)
}
