// swift-tools-version: 6.4

import Foundation // for String.capitalized
import PackageDescription

_ = Package(
  name: .LibraryName.unsuffixed,
  products: [
    .library(
      name: .LibraryName.unsuffixed,
      targets: [.LibraryName.unsuffixed]
    )
  ],
  dependencies:
    [Module.ExternalDependency.Swift.docC.package] // Necessary for documentation
    + Set(modules.flatMap(\.externalDependencies)).map(\.package),
  targets: modules.map(\.target)
)

/// The modules that make up this package.
var modules: [Module] {
  [ .init(
      target: .target(name: .LibraryName.unsuffixed)
    ),
    .init(
      target: .testTarget(
        name: .LibraryName.suffixed("Tests")
      ),
      internalDependencyNames: [.LibraryName.unsuffixed]
    )
  ]
}

extension String {
  enum LibraryName {
    static let unsuffixed = "InitializableByAssigningToSelf"
    static func suffixed(_ suffix: String) -> String {
      "\(unsuffixed).\(suffix)"
    }
  }
}

// MARK: - Module
struct Module {
  let target: Target
  let externalDependencies: [ExternalDependency]

  /// - Parameters:
  ///   - internalDependencyNames: Names of targets within this package.
  init(
    target: Target,
    internalDependencyNames: [String] = [],
    externalDependencies: [ExternalDependency] = []
  ) {
    target.dependencies += internalDependencyNames.map(Target.Dependency.init)
    target.dependencies += externalDependencies.flatMap(\.products)
    self.target = target
    self.externalDependencies = externalDependencies
  }
}

extension Module {
  /// A repository on GitHub.
  struct ExternalDependency {
    let organization: String
    let repositoryName: String
    let packageNames: [String]
    let branch: String
  }
}

// MARK: - Module.ExternalDependency
extension Module.ExternalDependency {
  // MARK: - commonly-used
  enum Swift {
    static var docC: Module.ExternalDependency { dependency(repositoryName: "docc-plugin") }

    private static func dependency(
      organization: String = "swiftlang", repositoryName: String,
      packageNames: [String]? = nil
    ) -> Module.ExternalDependency {
      .init(
        organization: organization,
        repositoryName: "swift-\(repositoryName)",
        packageNames:
          packageNames.map { names in names.map { "Swift\($0)" } }
          ?? [repositoryName.split(separator: "-").map(\.capitalized).joined()]
      )
    }
  }

  private init(organization: String, repositoryName: String, packageNames: [String], branch: String? = nil) {
    self.init(
      organization: organization,
      repositoryName: repositoryName,
      packageNames: packageNames,
      branch: branch ?? "main"
    )
  }

  // MARK: - instance members
  var package: Package.Dependency {
    .package(
      url: "https://github.com/\(organization)/\(repositoryName)",
      branch: branch
    )
  }

  var products: [Target.Dependency] {
    packageNames.map { .product(name: $0, package: repositoryName) }
  }
}

// MARK: Equatable
extension Module.ExternalDependency: Equatable {
  static func == (dependency0: Self, dependency1: Self) -> Bool {
    (dependency0.organization, dependency0.repositoryName) ==
    (dependency1.organization, dependency1.repositoryName)
  }
}

// MARK: Hashable
extension Module.ExternalDependency: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(organization)
    hasher.combine(repositoryName)
  }
}
