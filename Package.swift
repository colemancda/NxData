// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NxData",
    products: [
        .library(
            name: "NxData",
            targets: ["NxData"]
        ),
    ],
    targets: [
        .target(
            name: "NxData"
        ),
        .testTarget(
            name: "NxDataTests",
            dependencies: ["NxData"]
        ),
    ]
)
