# Work in Progress 👷‍♂️

<p align="center">
<img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/CodableStoreKitLogo.jpg" alt="CodableStoreKitLogo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" alt="Swift 4.1">
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
<p/>

## Features

- [x] Easily persist and retrieve Codable types 💾
- [x] Observe save and delete events 🕶
- [x] Container-Collection-Architecture 📦

## Installation

### CocoaPods

CodableStoreKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'CodableStoreKit', '~> 1.0.0'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate CodableStoreKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SvenTiigi/CodableStoreKit" ~> 1.0.0
```

Run `carthage update --platform iOS` to build the framework and drag the built `CodableStoreKit.framework` into your Xcode project. 

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

Step one make your Codable structs or classes conform to the `CodableStoreable` protocol.

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
        return \User.id
    }
    
}
```

Secondly initialize a specific `CodableStore` based on the type you want to persist.

```swift
// Initialize a User CodableStore
let codableStore = CodableStore<User>()
```

Now you are good to go to `save`, `delete`, `get` and `observe`.

```swift
// Initialize User
let user = User(id: "42", firstName: "Mr.", lastName: "Robot")

// Save / Update
try codableStore.save(user)

// Delete
try codableStore.delete(user)

// Get
let retrievedUser = try codableStore.get(identifier: "42")

// Observe
codableStore.observe(user) { (event) in
    switch event {
    case .saved(let object, let container):
        break
    case .deleted(let object, let container):
        break
    }
}
```

That's it 🙌 head over to the Advanced section to explore the full capabilities of the `CodableStoreKit`.

## Advanced
The Advanced section will explain all capabilities of the `CodableStoreKit` in depth.

### Architecture

`CodableStoreKit` is based on a `Container-Collection-Architecture`

<img align="right" src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/Container.png" alt="Container-Collection-Architecture" width=360>


#### Container
A Container is defined as a place to store and retrieve Collections in an encapsulated way. You can initialize a custom `CodableStoreContainer` and pass it to a `CodableStore` in order to encapsulate your collections.

```swift
// Initialize a custom CodableStoreContainer
let apiV1Container = CodableStoreContainer(name: "APIv1")

// Pass it to the CodableStore initializer
let codableStore = CodableStore<User>(container: apiV1Container)
```
> In default the `CodableStore` will use a default `CodableStoreContainer` with the name "Default".

#### Collection

A Collection can be defined as a typealias for all structs and classes which are conform to the `CodableStoreable` protocol. CodableStoreKit already supplied a default implementation to return a Collection name based on the name of the type. 

If you wish to supply a custom Collection name you can do it in the following way.

```swift
extension User {
    /// The CodableStore collection name
    static var codableStoreCollectionName: String {
        // In Default: return String(describing: type(of: self))
        return "MyCustomUserCollectionName"
    }
}
```

### Engine

The `CodableStoreEngine` is the main component which saves, delete and fetches Codable Data from an Container. You can decide which Engine-Implementation should be used when initializing a `CodableStore`.

```swift
// FileSystem Engine which uses the FileManager-API
let codableStore = CodableStore<User>(engine: .fileSystem)

// InMemory Engine
let codableStore = CodableStore<User>(engine: .inMemory)

// A custom CodableStoreEngine
let codableStore = CodableStore<User>(engine: .custom(myCustomEngine))
```
> In default the `.fileSystem` Engine will be used

### CodableStoreable

When making a type conform to the `CodableStoreable` protocol you can access convenience functions directly on an instance of your type in order to save, delete, get and observe.

```swift
// Save / Update
try user.save()

// Save in different container
try user.save(container: myContainer)

// Delete
try user.delete()

// Delete in different Engine
try user.delete(engine: .inMemory)

// Exists
let exists = user.exists()

// Observe
user.observe { (event) in
    // Evaluate if the Event is .saved or .deleted
}
```

As well as static functions on your type which is conform to the `CodableStoreable` protocol.

```swift
// Get
let retrievedUser = try User.get(identifier: "42")

// Get from different Container
let retrievedUser = try User.get(identifier: "42", container: myContainer)

// Get Users collection
let allUsers = try User.getCollection()

// Observe with filter
User.observe(where: { $0.lastName.contains("Robot") }) { (event) in
    // Evaluate if the Event is .saved or .deleted
}
```

If you want to suppress those convenience functions on your type you can _downgrade_ the `CodableStoreable` protocol to the `BaseCodableStoreable` protocol which removes the availability of those functions but still remains the conformance to use it with a `CodableStore`.

```swift
// Without convience functions on type
extension User: BaseCodableStoreable {}

// With convience functions
extension User: CodableStoreable {}
```

### Observation

In order to retrieve callbacks when a certain object has been saved or deleted in a Container you can make use of the aforementioned `observe` functions. When you invoke the `oberserve` API you will retrieve a `ObserverableCodableStoreSubscription` in order to unsubscribe and avoid memory leaks.

```swift
// Initialize a CodableStore
let codableStore = CodableStore<User>()

// Observe an Store Subscription
let subscription = codableStore.observe(identifier: "42") { event in
    switch event {
    case .saved(let object, let container):
        break
    case .deleted(let object, let container):
        break
    }
}

// Manually invoke unsubscribe
subscription.unsubscribe()
```

Or you can use the `ObserverableCodableStoreSubscriptionBag` in order to automatically unsubscribe.

```swift
class MyCustomClass {

    /// The SubscriptionBag
    let subscriptionBag = ObserverableCodableStoreSubscriptionBag()

    /// Designated Initializer
    init() {
        // Observe User with Identifier and dispose it by SubscriptionBag
        User.observe(identifier: "42") { event in
            print(event)
        }.disposed(by: self. subscriptionBag)
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
