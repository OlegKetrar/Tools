# Tools

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

### Reusable package
- `Reusable` 
- `NibInitable`
- `StoryboardInitable` 

### ToolsFoundation package
- `NotificationObserver` - convenience auto-unsubscribed observer.
- `Section<Into, Item>`
- `HasApply` protocol
- [RoutingController](#RoutingController)
- various `String` extensions

### Tools package
- `KeyboardObserver`
- `SliderAdapter` - declarative block-based `UICollectionView` adapter
- `SearchController` - declarative block-based `UISearchController` abstraction
- [Button](#button-with-preloader) - `UIButton` with with preloader, prevents multiple execution
- [Switch](#switch) - `UISwitch` with control of value changing
- [Presentation](#presentation) - abstraction around presenting/dismissing of `UIViewController`s
- `UIColor` extensions
- AutoLayout extensions

## Requirements

- Swift 5.2+
- xCode 11.7+
- iOS 9.0+

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/OlegKetrar/Tools", .exact("0.6")),
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate Tools into your Xcode project using `Carthage`, specify it in your `Cartfile`:

```ogdl
github "OlegKetrar/Tools" == 0.6
```
Run `carthage update` to build the framework and drag the built `Tools.framework` into your Xcode project.

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
