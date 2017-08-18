# Tools

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Features

- [x] `Carthage` support
- [ ] `CocoaPods` support
- [ ] `Swift PM` support
- [x] `Reusable` / `NibInitable` / `StoryboardInitable`
- [x] `SliderAdapter` - declarative block-based `UICollectionView` adapter
- [x] `EventObserver` / `KeyboardObserver`
- [x] `SearchController` - declarative block-based `UISearchController` abstraction
- [x] `Button` - `UIButton` with with preloader, prevents multiple execution
- [x] `Switch` - `UISwitch` with control of value changing 
- [x] `Presentation` - abstraction around presenting/dismissing of `UIViewController`s
- [ ] `FormatController` provides control for inputting of strongly formatted strings
- [ ] Refactor `UIView` animation convenience
- [ ] Material-like `UITextField`
- [ ] Declarative block-based `UITableView` with `Section` abstraction
- [ ] implement `Error` model 

## Repo organization

- [ ] Usage section
- [ ] Separate `UIKit` extensions and `swift` crossplatform features
- [ ] Documentation in code

## Usage

## Requirements

- Swift 3.1+
- xCode 8.0+
- iOS 8.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate Tools into your Xcode project using `Carthage`, specify it in your `Cartfile`:

```ogdl
github "OlegKetrar/Tools" == 0.3.1
```
Run `carthage update` to build the framework and drag the built `Tools.framework` into your Xcode project.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ brew update
$ brew install cocoapods
```

or 

```bash
$ gem install cocoapods
```

To integrate Tools into your Xcode project using `CocoaPods`, specify it in your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'Tools', :git => 'https://github.com/OlegKetrar/Tools.git', :tag => '0.3.1'
end
```

Then, run the following command:

```bash
$ pod install
```

## License

Tools is released under the MIT license. [See LICENSE](LICENSE.md) for details.
