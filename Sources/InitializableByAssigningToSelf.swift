/// Adds the ability to "assign `self`" to reference types.
///
/// ## Why this exists
///
/// A value type can be initialized by assigning to `self`. A reference type cannot.
/// The workaround is to define a `self`-assigning `init` in a protocol extension.
/// This is that protocol.
///
/// ## Usage
///
/// ```swift
/// class Class {
///   required init(property: String) { }
///   static var instance: Self { .init(property: "🐱") }
/// }
///
/// extension Class: InitializableByAssigningToSelf {
///   convenience init() { self.init(assigningSelfTo: .instance) }
/// }
/// ```
///
/// - Warning: The compiler doesn't check that the instance is a `Self`. A subclass that inherits your initializer
///   crashes if the initializer supplies an instance that isn't that subclass.
public protocol InitializableByAssigningToSelf {
  /// The type that `init(assigningSelfTo:)` accepts.
  ///
  /// - Important: Always use the default `Self` for this.
  ///
  /// `assigningSelfTo instance`'s type cannot just be `Self`,
  /// due to limitations involving `Self` and subclassing.
  associatedtype SelfOrSubclass: AnyObject = Self
}

public extension InitializableByAssigningToSelf {
  /// Assigns `instance` to `self`.
  ///
  /// - Precondition: `instance` is a `Self`. (Using `SelfOrSubclass`'s default ensures this.)
  init(assigningSelfTo instance: SelfOrSubclass) { self = instance as! Self }
}
