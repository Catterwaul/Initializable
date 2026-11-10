# ``InitializableByAssigningToSelf``

An initializer for reference types that assigns an existing instance to `self`.

Value types can write `self = …` in their initializers. Reference types can't, but a protocol extension's initializer can. Conform to ``InitializableByAssigningToSelf`` to get `init(assigningSelfTo:)`, and use it to return a shared instance, or an instance of a subclass, from your own initializers.

### Usage Examples

You've got the source code, so aside from reading this documentation, see the **Tests** folder for example usage! 😺
