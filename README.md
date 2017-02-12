# Tools

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Features

- [x] Carthage support
- [ ] CocoaPods support
- [ ] Swift PM support
- [ ] Refactor UIView animation convenience
- [ ] Add all permissions requests
- [ ] Material like UITextField
- [ ] Refactor AlertDispatcher
- [ ] Declarative block-based UITableView & UICollectionView

## Repo organization

- [ ] Usage section
- [ ] Separate UIKit extensions and swift crossplatform features
- [ ] Documentation
- [ ] Separate AlertDispatcher

## Usage

## Requirements

- Swift 3.0+
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
To integrate NumberPad into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "OlegKetrar/Tools"
```
Run `carthage update` to build the framework and drag the built `Tools.framework` into your Xcode project.
