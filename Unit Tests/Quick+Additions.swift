import Quick

public func describe(_ type: AnyObject.Type, flags: FilterFlags = [:], closure: () -> ()) {
    describe(String(describing: type), flags: flags, closure: closure)
}

public func context(_ selectorOrFunction: Any, flags: FilterFlags = [:], closure: () -> ()) {
    context(String(describing: selectorOrFunction), flags: flags, closure: closure)
}

public func fcontext(_ selectorOrFunction: Any, flags: FilterFlags = [:], closure: () -> ()) {
    fcontext(String(describing: selectorOrFunction), flags: flags, closure: closure)
}
