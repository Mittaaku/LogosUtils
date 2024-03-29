// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogosUtils",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "LogosUtils",
            targets: ["LogosUtils"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/groue/GRDB.swift", .upToNextMajor(from: "6.15.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "LogosUtils",
            dependencies: [
				.product(name: "GRDB", package: "GRDB.swift")
			]),
        .testTarget(
            name: "LogosUtilsTests",
            dependencies: ["LogosUtils"])
    ]
)
