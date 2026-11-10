import InitializableByAssigningToSelf
import Testing

struct Tests {
  @Test func `Assigns the instance to self`() {
    #expect(Cat() == .frisky)
  }

  @Test func `A superclass can assign a subclass instance to self`() {
    #expect(Buddy() is Cat)
  }

  @Test func `A subclass crashes when an inherited initializer supplies a superclass instance`() async {
    await #expect(processExitsWith: .failure) { _ = Kitten() }
  }
}

private class Buddy {
  let image: String
  init(image: String) { self.image = image }
}

extension Buddy: Equatable {
  static func == (buddy0: Buddy, buddy1: Buddy) -> Bool {
    buddy0.image == buddy1.image
  }
}

private class Cat: Buddy { }
private final class Kitten: Cat { }

extension Buddy {
  static var frisky: Cat { .init(image: "🐈‍⬛") }
}

extension Buddy: InitializableByAssigningToSelf {
  convenience init() { self.init(assigningSelfTo: .frisky) }
}
