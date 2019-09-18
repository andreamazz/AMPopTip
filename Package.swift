// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "AMPopTip",
  products: [
    .library(
      name: "AMPopTip",
      targets: ["AMPopTip"])
  ],
  targets: [
    .target(
      name: "AMPopTip",
      path: "Source")
  ]
)
