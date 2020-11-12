// swift-tools-version:5.0

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

 let products = [
        .library(
            name: "AppCenterAnalytics",
            type: .static,
            targets: ["AppCenterAnalytics"]),
        .library(
            name: "AppCenterCrashes",
            type: .static,
            targets: ["AppCenterCrashes"])
    ]

 let targets = [
        .target(
            name: "AppCenter",
            path: "AppCenter/AppCenter",
            exclude: ["Support"],
            cSettings: [
                .define("APP_CENTER_C_VERSION", to:"\"4.0.1\""),
                .define("APP_CENTER_C_BUILD", to:"\"1\""),
                .headerSearchPath("**"),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
                .linkedFramework("Foundation"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("CoreTelephony", .when(platforms: [.iOS, .macOS])),
            ]
        ),
        .target(
            name: "AppCenterAnalytics",
            dependencies: ["AppCenter"],
            path: "AppCenterAnalytics/AppCenterAnalytics",
            exclude: ["Support"],
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("../../AppCenter/AppCenter/**"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
            ]
        ),
        .target(
            name: "AppCenterCrashes",
            dependencies: ["AppCenter", "CrashReporter"],
            path: "AppCenterCrashes/AppCenterCrashes",
            exclude: ["Support"],
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("../../AppCenter/AppCenter/**"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
            ]
        )
    ]

#if swift(>=5.3)
    products.append(.library(
                    name: "AppCenterDistribute",
                    type: .static,
                    targets: ["AppCenterDistribute"]))
    targets.append(.target(
                    name: "AppCenterDistribute",
                    dependencies: ["AppCenter"],
                    path: "AppCenterDistribute/AppCenterDistribute",
                    exclude: ["Support"],
                    resources: [
                        .process("Resources/AppCenterDistribute.strings")
                    ],
                    cSettings: [
                        .headerSearchPath("**"),
                        .headerSearchPath("../../AppCenter/AppCenter/**"),
                    ],
                    linkerSettings: [
                        .linkedFramework("Foundation"),
                        .linkedFramework("UIKit", .when(platforms: [.iOS])),
                    ]
        ))
 #endif

#if swift(>=5.3)
let package = Package(
    name: "App Center",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v11)
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/microsoft/plcrashreporter.git", .upToNextMinor(from: "1.8.0")),
    ],
    targets: targets,
)
#else
let package = Package(
    name: "App Center",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v11)
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/microsoft/plcrashreporter.git", .upToNextMinor(from: "1.8.0")),
    ],
    targets: targets,
)
 #endif
