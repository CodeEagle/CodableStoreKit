# Work in Progress 👷‍♂️

<p align="center">
<img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/CodableStoreKitLogo.jpg" alt="CodableStoreKitLogo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0">
   </a>
   <a href="http://cocoapods.org/pods/CodableStoreKit">
      <img src="https://img.shields.io/cocoapods/v/CodableStoreKit.svg?style=flat" alt="Version">
   </a>
   <a href="https://github.com/Carthage/Carthage">
      <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage Compatible">
   </a>
   <a href="http://cocoapods.org/pods/CodableStoreKit">
      <img src="https://img.shields.io/cocoapods/p/CodableStoreKit.svg?style=flat" alt="Platform">
   </a>
   <br/>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>	
   <a href="https://sventiigi.github.io/CodableStoreKit">
      <img src="https://github.com/SvenTiigi/CodableStoreKit/blob/gh-pages/badge.svg" alt="Documentation">
   </a>
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

<br/>

<p align="center">
CodableStoreKit is a lightweight Codable Persistence Framework for iOS, macOS, watchOS and tvOS.
<br/>
It allows you to simply persist, retrieve and observe your Codable structs and classes.
</p>

<br/>

<p align="center">
   <img width="70%" src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/CodableTyping.gif" alt="CodableTyping" />
   <br/><br/>
</p>

## Features

- [x] Easily persist and retrieve Codable types 💾
- [x] Observe save and delete events 🕶

## Installation

### CocoaPods

CodableStoreKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'CodableStoreKit'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate CodableStoreKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SvenTiigi/CodableStoreKit"
```

Run `carthage update` to build the framework and drag the built `CodableStoreKit.framework` into your Xcode project. 

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the Framework path as mentioned in [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md)

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Once you have your Swift package set up, adding CodableStoreKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/SvenTiigi/CodableStoreKit.git", from: "1.0.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate CodableStoreKit into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

### Step 1

Make your Codable structs or classes conform to the `CodableStorable` protocol.

```swift
/// The User Struct
struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
}

// MARK: - CodableStorable

extension User: CodableStorable {

    /// The CodableStore unique identifier KeyPath
    static var codableStoreIdentifier: KeyPath<User, String> {
        // Return a KeyPath to a property which uniquely identifies an User
        return \.id
    }
    
}
```

### Step 2

Initialize a specific `CodableStore` based on the type you want to operate on.

```swift
// Initialize a User CodableStore
let codableStore = CodableStore<User>()
```

### Step 3

Now you are good to go to persist, retrieve and observe your CodableStoreable 😎

```swift
// Initialize an User
let user = User(id: "42", firstName: "Mr.", lastName: "Robot")

// Save
switch codableStore.save(user) {
case .success(let user):
    print("Saved", user)
case .failure(let error):
    print("Saving failed", error)
}

// Retrieve by Identifier
switch codableStore.get("42") {
case .success(let user):
    print("User retrieved by Identifier", user)
case .failure(let error):
    print("Failed to retrieve User by Identifier", error)
}

// Retrieve all
switch codableStore.getAll() {
case .success(let users):
    print("Get all Users", users)
case .failure(let error):
    print("Retrieving all failed", error)
}

// Delete
switch codableStore.delete(user) {
case .success:
    print("Deleted User")
case .failure(let error):
    print("Failed to delete User", error)
}

// Delete all
switch codableStore.deleteAll() {
case .success:
    print("Deleted all Users")
case .failure(let error):
    print("Failed to delete all Users", error)
}
```

## Advanced
The Advanced section will explain all configuration possibilities and features of the `CodableStoreKit` in detail.

## Contributing
Contributions are very welcome 🙌 🤓

## License

```
CodableStoreKit
Copyright (c) 2019 Sven Tiigi <sven.tiigi@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
