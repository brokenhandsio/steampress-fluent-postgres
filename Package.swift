// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SteampressFluentPostgres",
    products: [
        .library(
            name: "SteampressFluentPostgres",
            targets: ["SteampressFluentPostgres"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/brokenhandsio/SteamPress.git", from: "1.0.0"),
         .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SteampressFluentPostgres",
            dependencies: ["SteamPress", "FluentPostgreSQL"]),
        .testTarget(
            name: "SteampressFluentPostgresTests",
            dependencies: ["SteampressFluentPostgres"]),
    ]
)
