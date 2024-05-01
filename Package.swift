// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NxData",
    platforms: [
        .macOS("11"),
        .iOS("14"),
        .tvOS("14"),
        .watchOS("7")
    ],
    products: [
        .library(
            name: "NxData",
            targets: ["NxData"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-system",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "NxData",
            dependencies: [
                .product(
                    name: "SystemPackage",
                    package: "swift-system"
                )
            ]
        ),
        .testTarget(
            name: "NxDataTests",
            dependencies: ["NxData"],
            resources: [
                .copy("Data.nx"),
            ]
        ),
    ]
)
