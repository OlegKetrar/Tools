# Tools

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] `Carthage` support
- [ ] `CocoaPods` support
- [ ] `Swift PM` support
- [x] [Reusable](#reusable) / [NibInitable](#nibinitable) / [StoryboardInitable](#storyboardinitable)
- [x] [SliderAdapter](#slideradapter) - declarative block-based `UICollectionView` adapter
- [x] [NotificationObserver](#notificationobserver) / [KeyboardObserver](#keyboardobserver)
- [x] [SearchController](#searchcontroller) - declarative block-based `UISearchController` abstraction
- [x] [Button](#button-with-preloader) - `UIButton` with with preloader, prevents multiple execution
- [x] [Switch](#switch) - `UISwitch` with control of value changing
- [x] [Presentation](#presentation) - abstraction around presenting/dismissing of `UIViewController`s
- [ ] `FormatController` provides control for inputting of strongly formatted strings
- [ ] Refactor `UIView` animation convenience
- [ ] Material-like [TextField](#material-like-text-field)
- [ ] [live complex validation](#validationcondition) with [styling](#styling)
- [ ] Declarative block-based `UITableView` with `Section` abstraction
- [ ] implement `Error` model

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

## Usage

### Reusable

### NibInitable

### StoryboardInitable

### Button with preloader
Used `disabled` state to show preloader on button. Disallow all touchs and hides `title` and `attributedTitle`
while preloader is active. By setting flag `shouldAffectImage` to `false` you can show image while if preloader is active.
By default `true`.

```swift
let actionButton = Button(frame: .zero)
...

// you can define preloader color.
// other poperties you can change in the usual way.
actionButton.preloaderColor = .white

// you always need to call `finish` closure and call it only on main queue.
actionButton.start(activity: { (finish) in
  doSomethingAsyncronousWithCallback {
    // finish work and stop `preloader` on button
    DispatchQueue.main.async { finish() }
  }
})
```

Also you can explicitly control preloader with `startPreloader()` and `stopPreloader()`.

### Switch
Adds control to value changing.

```swift
let someSwitch = Switch(frame: .zero)
// setup autolayout

// ask you every time somebody toggle switch.
someSwitch.onShouldChangeValue { (proposedValue) in

  // return `true` to change to `proposedValue` or `false` to not.
  return canEnableSmth(proposedValue)
}
```

### Material-like text field
Brings new level of validation abstraction.

#### Styling

#### ValidationCondition

### NotificationObserver
Convenience auto-unsubscribed observer.

### KeyboardObserver

### SearchController

### SliderAdapter
Block-base adapter for `UICollectionView`.

### RoutingController
Allows you to define your custom app routes and hanlde them with `open(url:)` method.

### Presentation
Abstraction around `present/push` and `dismiss/pop`.
`Presentation` represents just a method for showing view controller. Has three built in methods:

```swift
// create presentation for presenting controllers over someMyVC
let modalyOverMyVC = Presentation.present(over: someMyVC)

// create presentation for pushing into someMyNC
let pushIntoMyNC = Presentation.push(into: someMyVC)

// create presentation for presenting over current topmost controller
let modallyOverTopVC = Presentation.presentOverTop()
```

Then you can use it for displaying specific view controller:

```swift
somePresentation.show(someViewControllerToShow, animated: true, completion: {
    // do smth
})
```

And then unwind it:

```swift
somePresentation.hide(animated: true, completion: {
    // do smth
})
```

You need to `hide` concrete `Presentation` which you already `show`.
Presentation does not retain navigation controller or presented view controller presenting view controller.

## License

Tools is released under the MIT license. [See LICENSE](LICENSE.md) for details.
