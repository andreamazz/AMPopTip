![GitHub Actions CI](https://github.com/ashfurrow/Nimble-Snapshots/actions/workflows/build-and-test.yml/badge.svg?branch=master)
[![Cocoapods compatible](https://img.shields.io/cocoapods/v/Nimble-Snapshots.svg)](https://cocoapods.org/?q=Nimble-Snapshots)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/github/license/ashfurrow/Nimble-Snapshots.svg)](https://github.com/ashfurrow/Nimble-Snapshots/blob/master/LICENSE)
=============================

[Nimble](https://github.com/Quick/Nimble) matchers for [iOSSnapshotTestCase](https://github.com/uber/ios-snapshot-test-case).
Originally derived from [Expecta Matchers for FBSnapshotTestCase](https://github.com/dblock/ios-snapshot-test-case-expecta).

<p align="center">
<img src="http://gifs.ashfurrow.com/click.gif" />
</p>

Installing
----------

## CocoaPods

You need to be using CocoaPods 0.36 Beta 1 or higher. Your `Podfile` should look
something like the following.

```rb
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

# Whichever pods you need for your app go here.

target 'YOUR_APP_NAME_HERE_Tests', :exclusive => true do
  pod 'Nimble-Snapshots'
  pod 'Quick' # if you want to use it with Quick
end
```

Then run:
```
$ pod install
```

## Carthage

You need to be using Carthage 0.18 or higher. Your `Cartfile` (or `Cartfile.private`) should look
something like the following.

```rb
github "Quick/Quick" ~> 4.0
github "Quick/Nimble" ~> 9.2
github "uber/ios-snapshot-test-case" "8.0.0"
github "ashfurrow/Nimble-Snapshots"
```

Then run:
```
$ carthage bootstrap --use-xcframeworks --platform iOS
```

## Swift Package Manager

To add `Nimble-Snapshots` as a dependency, you have to add it to the dependencies of your `Package.swift` file and refer to that dependency in your target.

```swift
import PackageDescription
let package = Package(
    name: "<Your Product Name>",
    dependencies: [
       .package(url: "https://github.com/ashfurrow/Nimble-Snapshots", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "<Your Target Name>",
            dependencies: ["Nimble-Snapshots"]),
    ]
)
```

Use
---

Your tests will look something like the following.

```swift
import Quick
import Nimble
import Nimble_Snapshots
import UIKit

class MySpec: QuickSpec {
    override func spec() {
        describe("in some context") {
            it("has valid snapshot") {
                let view = ... // some view you want to test
                expect(view).to( haveValidSnapshot() )
            }
        }
    }
}
```

There are some options for testing the validity of snapshots. Snapshots can be
given a name:

```swift
expect(view).to( haveValidSnapshot(named: "some custom name") )
```

We also have a prettier syntax for custom-named snapshots:

```swift
expect(view) == snapshot("some custom name")
```

To record snapshots, just replace `haveValidSnapshot()` with `recordSnapshot()`
and `haveValidSnapshot(named:)` with `recordSnapshot(named:)`. We also have a
handy emoji operator.

```swift
📷(view)
📷(view, "some custom name")
```

By default, this pod will put the reference images inside a `ReferenceImages`
directory; we try to put this in a place that makes sense (inside your unit
tests directory). If we can't figure it out, or if you want to use your own
directory instead, call `setNimbleTestFolder()` with the name of the directory
in your unit test's path that we should use. For example, if the tests are in
`App/AppTesting/`, you can call it with `AppTesting`.

If you have any questions or run into any trouble, feel free to open an issue
on this repo.

## Dynamic Type

Testing Dynamic Type manually is boring and no one seems to remember doing it
when implementing a view/screen, so you can have snapshot tests according to
content size categories.

In order to use Dynamic Type testing, make sure to provide a valid `Host Application` in your testing target.

Then you can use the `haveValidDynamicTypeSnapshot` and
`recordDynamicTypeSnapshot` matchers:

```swift
// expect(view).to(recordDynamicTypeSnapshot()
expect(view).to(haveValidDynamicTypeSnapshot())

// You can also just test some sizes:
expect(view).to(haveValidDynamicTypeSnapshot(sizes: [UIContentSizeCategoryExtraLarge]))

// If you prefer the == syntax, we got you covered too:
expect(view) == dynamicTypeSnapshot()
expect(view) == dynamicTypeSnapshot(sizes: [UIContentSizeCategoryExtraLarge])
```

Note that this will post an `UIContentSizeCategoryDidChangeNotification`,
so your views/view controllers need to observe that and update themselves.

For more info on usage, check out the
[dynamic type tests](Bootstrap/BootstrapTests/DynamicTypeTests.swift).



## Dynamic Size

Testing the same view with many sizes is easy but error prone. It easy to fix one test
on change and forget the others. For this we create a easy way to tests all sizes at same time.

You can use the new `haveValidDynamicSizeSnapshot` and `recordDynamicSizeSnapshot`
matchers to test multiple sizes at once:

```swift
let sizes = ["SmallSize": CGSize(width: 44, height: 44),
"MediumSize": CGSize(width: 88, height: 88),
"LargeSize": CGSize(width: 132, height: 132)]

// expect(view).to(recordDynamicSizeSnapshot(sizes: sizes))
expect(view).to(haveValidDynamicSizeSnapshot(sizes: sizes))

// You can also just test some sizes:
expect(view).to(haveValidDynamicSizeSnapshot(sizes: sizes))

// If you prefer the == syntax, we got you covered too:
expect(view) == snapshot(sizes: sizes)
expect(view) == snapshot(sizes: sizes)
```

By default, the size will be set on the view using the frame property. To change this behavior
you can use the `ResizeMode` enum:

```swift
public enum ResizeMode {
  case frame
  case constrains
  case block(resizeBlock: (UIView, CGSize) -> Void)
  case custom(viewResizer: ViewResizer)
}
```
To use the enum you can `expect(view) == dynamicSizeSnapshot(sizes: sizes, resizeMode: newResizeMode)`.
For custom behavior you can use `ResizeMode.block`. The block will be call on every resize. Or you can
implement the `ViewResizer` protocol and resize yourself.
The custom behavior can be used to record the views too.

For more info on usage, check the [dynamic sizes tests](Bootstrap/BootstrapTests/DynamicSizeTests.swift).
