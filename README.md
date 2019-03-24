# Work in Progress 👷‍♂️

<p align="center">
<img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/CodableStoreKitLogo.jpg" alt="CodableStoreKitLogo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift 4.2">
   </a>
   <a href="https://travis-ci.com/SvenTiigi/CodableStoreKit">
      <img src="https://travis-ci.com/SvenTiigi/CodableStoreKit.svg?branch=master" alt="Build Status">
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
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>	
   <br/>
   <a href="https://codeclimate.com/github/SvenTiigi/CodableStoreKit/maintainability">
      <img src="https://api.codeclimate.com/v1/badges/3ebe590866dd344de148/maintainability" alt="Maintainability">
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
- [x] Engine-Container-Collection-Architecture 📦
- [x] Type Safety and Access-Control-System 🔒

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

Run `carthage update --platform` to build the framework and drag the built `CodableStoreKit.framework` into your Xcode project. 

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

Make your Codable structs or classes conform to the `CodableStoreable` protocol.

```swift
/// The User Struct
struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
}

// MARK: - CodableStoreable

extension User: CodableStoreable {

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
try codableStore.save(user)

// Delete
try codableStore.delete(user)

// Get
let retrievedUser = try codableStore.get(identifier: "42")

// Observe
codableStore.observe(user) { event in
    switch event {
    case .saved(let user, let container):
        // The User has been saved in Container
        break
    case .deleted(let user, let container):
        // The User has been deleted in Container
        break
    }
}
```
> A full list of available API's can be found [here](https://sventiigi.github.io/CodableStoreKit/Classes/CodableStore.html)

## Advanced
The Advanced section will explain all configuration possibilities and features of the `CodableStoreKit` in detail.

### Engine-Container-Collection-Architecture

`CodableStoreKit` is based on an `Engine-Container-Collection-Architecture (ECCA)`. 

The architecture allows a `CodableStore` to use different `CodableStoreEngine` implementations wich are persisting data in their very own way. For instance the `InMemoryCodableStoreEngine` is holding the `CodableStoreable` objects in memory while a `FileManagerCodeableStoreEngine` will save all its data in the FileSystem.

<p align="center">
	<img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/Architecture.jpg" alt="Architecture">
</p>

Each `CodableStoreEngine` can manage multiple `Containers` which allows you to store the same or different type of a Collection in an encapsulated section inside an `CodableStoreEngine `. A `Collection` can be described as a group of related object types.

### Engine

TODO: Add text

If you wish you can implement your own `CodableStoreEngine`.

```swift
class MyCustomEngine: CodableStoreEngine {
    // TODO: Implement me 👨‍💻
}
```
As soon as you implemented your custom `CodableStoreEngine` you can pass it to a `CodableStore`.

```swift
// Initialize CodableStore with Custom Engine
let codableStore = CodableStore<User>(engine: MyCustomEngine())
```

### Container

To decide which `Container` should be used when persisting or retrieving Codables you can pass a `CodableStoreContainer` to the `initializer` of a `CodableStore`.

```swift
// Initialize a custom CodableStoreContainer
let debugContainer = CodableStoreContainer(name: "DebugContainer")

// Pass it to the CodableStore initializer
let codableStore = CodableStore<User>(container: debugContainer)
```
> ☝️ In default the `.default` `CodableStoreContainer` will be used with the name "Default"

### Collection

As mentioned before a `Collection` is a group of realted object types. This means every struct or class that is conform to the `CodableStoreable` protocol is a `Collection`. Therefore a `Collection` is identified via a name. In default the name of a `Collection` is the name of the type.

```swift
// Print the CodableStore Collection-Name
print(User.codableStoreCollectionName) // User.Type
```

If you wish to supply a custom `Collection` name you can override the static `codableStoreCollectionName` property.

```swift
extension User {

    /// The CodableStore collection name
    static var codableStoreCollectionName: String {
        // In Default: return String(describing: type(of: self))
        return "MyCustomUserCollectionName"
    }
    
}
```

### Manager

TODO: Add Text

### Access-Control

A `CodableStore` enables you to access all functions to save, delete, read and observe CodableStoreables. If you wish to use a `CodableStore` in delete-only or read-only mode you can make use of the `AccessControl` properties.

```swift
let codableStore = CodableStore<User>()

// Save-Only CodableStore
let saveableCodableStore = codableStore.accessControl.saveable

// Delete-Only CodableStore
let readableCodableStore = codableStore.accessControl.deletable

// Read-Only CodableStore
let readableCodableStore = codableStore.accessControl.readable

// Observe-Only CodableStore
let observableCodableStore = codableStore.accessControl.observable
```

### Observation

In order to retrieve callbacks / notifications when a certain CodableStorable type has been saved or deleted in a Container you can make use of the aforementioned `observe` functions. When you invoke the `oberserve` function you will retrieve a `CodableStoreSubscription` in order to invalidate it and avoid memory leaks.

```swift
// Initialize a CodableStore
let codableStore = CodableStore<User>()

// Observe save and delete of Users where lastName contains "Robot"
let subscription = codableStore.observe(where: { $0.lastName.contains("Robot") }) { event in
    switch event {
    case .saved(storable: let user, container: let container):
        break
    case .deleted(storable: let user, container: let container):
        break
    }
}

// Manually invalidate subscription
subscription.invalidate()
```

Or you can use the `CodableStoreSubscriptionBag` in order to automatically invalidate the subscription.

```swift
class MyCustomClass {

    /// The CodableStore
    let codableStore = CodableStore<User>()

    /// The CodableStoreSubscriptionBag
    let subscriptionBag = CodableStoreSubscriptionBag()

    /// Designated Initializer
    init() {
        // Observe all Users and dispose it by SubscriptionBag
        self.codableStore.observeCollection { event in
            print(event)
        }.invalidated(by: self.subscriptionBag)
    }

}

```

## Contributing
Contributions are very welcome 🙌 🤓

## License

```
CodableStoreKit
Copyright (c) 2018 Sven Tiigi <sven.tiigi@gmail.com>

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
