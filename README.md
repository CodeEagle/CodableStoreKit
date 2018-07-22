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

Secondly initialize a specific `CodableStore` based on the type you want to operate on.

```swift
// Initialize a User CodableStore
let codableStore = CodableStore<User>()
```

Now you are good to go to persist, retrieve and observe your CodableStoreable type.

```swift
// Initialize User
let user = User(id: "42", firstName: "Mr.", lastName: "Robot")

// Save / Update
try codableStore.save(user)

// Delete
try codableStore.delete(user)

// Get
let retrievedUser = try codableStore.get(identifier: "42")

// Exists
let userExists = codableStore.exists(user)

// Observe
codableStore.observe(user) { (event) in
    switch event {
    case .saved(let object, let container):
        break
    case .deleted(let object, let container):
        break
    }
}

// Or use the convenience functions on your CodableStoreable type
try user.save()
```
> A full list of available API's can be found [here](https://sventiigi.github.io/CodableStoreKit/Classes/CodableStore.html)

That's it 🙌 head over to the Advanced section to explore the full capabilities of the `CodableStoreKit`.

## Advanced
The Advanced section will explain all capabilities of the `CodableStoreKit` in depth. 

### Engine-Container-Collection-Architecture

The `CodableStoreKit` is based on an `Engine-Container-Collection-Architecture`.

<p align="center">
	<img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/Architecture.jpg" alt="Architecture">
</p>

The architecture allows a `CodableStore` to use different Engine-Implementations which are persisting data in a unique way. For instance the `InMemoryCodableStoreEngine` stores data in an instance property and the `FileManagerCodableStoreEngine` persist the data in the Filesystem. Each `Engine` can manage multiple `Containers` which allows you to store the same or different type of a Collection in an encapsulated section inside an `Engine`. A `Collection` can be described as a group of related object types.

Best of all you can configure the `Engine-Container-Collection-Architecture` to your needs 🙌

### Engine

You can pass the `CodableStoreEngine` that should be used of a `CodableStore` by simply passing it to the `initializer`.

```swift
// Use the FileSystem Engine
let codableStore = CodableStore<User>(engine: .fileSystem)

// Use the InMemory Engine (perfect for development or testing phase)
let codableStore = CodableStore<User>(engine: .inMemory)

// Or use your own CodableStoreEngine
let codableStore = CodableStore<User>(engine: .custom(myCustomEngine))
```
> ☝️ In default the `.fileSystem` Engine will be used

#### Custom Engine

If you wish to define your own `CodableStoreEngine` you have to declare your Engine with a generic object type which is at least conform to the `BaseCodableStoreable` protocol. You have to do so to satisfy the associatedtype of the `CodableStoreEngine` protocol.

```swift
class MyEngine<Object: BaseCodableStoreable>: CodableStoreEngine {
    
    func get(identifier: Object.ID) throws -> Object {}
    
    func getCollection() throws -> [Object] {}
    
    func save(_ object: Object) throws -> Object {}
    
    func delete(identifier: Object.ID) throws -> Object {}
    
}
```

After you implemented the four functions `get`, `getCollection`, `save` and `delete` you can pass your own `CodableStoreEngine` to a `CodableStore` by wrapping it in an `AnyCodableStoreEngine` which is a type erasure struct.

```swift
// Initialize your Engine with an AnyCodableStoreEngine
let myEngine = AnyCodableStoreEngine<User>(MyEngine())

// Initialize a CodableStore with a custom Engine
let codableStore = CodableStore<User>(engine: .custom(myEngine))
```

### Container

To decide which `Container` should be used when persisting or retrieving Codables you can pass a `CodableStoreContainer` to the `initializer` of a `CodableStore`.

```swift
// Initialize a custom CodableStoreContainer
let apiV1Container = CodableStoreContainer(name: "APIv1Container")

// Pass it to the CodableStore initializer
let codableStore = CodableStore<User>(container: apiV1Container, engine: .fileSystem)
```
> ☝️ In default the `.default` `CodableStoreContainer` will be used with the name "Default"

Different Containers comes handy when you want to store your Codable-Models which are retrieved via a versioned `JSON-API` in an encapsulated area inside an engine. Or you want to store some encapsulated test data beside productiv data.

<p align="center">
   <img src="https://raw.githubusercontent.com/SvenTiigi/CodableStoreKit/gh-pages/readMeAssets/Containers.jpg" alt="Containers">
</p>

### Collection

As mentioned before a `Collection` is a group of realted object types. This means every struct or class that is conform to the `CodableStoreable`/`BaseCodableStoreable` protocol is a `Collection`. Therefore a `Collection` is identified via a name. In default the name of a `Collection` is the name of the type.

```swift
// A User struct
struct User: CodableStoreable {}

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

#### Encoder & Decoder

According to the `codableStoreCollectionName` you can override the specific `Encoder` and `Decoder` which should be used when serializing and deserializing data.

```swift
extension User {

    /// The CodableStore Coder
    static var codableStoreCoder: Coder {
        return (JSONEncoder(), JSONDecoder())
    }
    
}
```
> ☝️ In default the `JSONEncoder` and `JSONDecoder` will be used

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
```

As well as static functions on your type which is conform to the `CodableStoreable` protocol.

```swift
// Get
let retrievedUser = try User.get(identifier: "42")

// Get from different Container
let retrievedUser = try User.get(identifier: "42", container: myContainer)

// Get Users collection
let allUsers = try User.getCollection()
```

Last but not least convenience functions are also available on `CodableStoreable` Arrays.

```swift
// User Array
var users: [User] = .init()

// Save all Users
users.save()

// Delete all Users
users.delete()
```

### BaseCodableStoreable

If you want to suppress those convenience functions on your type you can _downgrade_ the `CodableStoreable` protocol to the `BaseCodableStoreable` protocol which removes the availability of those aforementioned functions but still remains the conformance to use it with a `CodableStore`.

```swift
// try user.save() ✅ (available)
extension User: CodableStoreable {}

// try user.save() ❌ (unavailable)
extension User: BaseCodableStoreable {}

// But both CodableStoreable and BaseCodableStoreable 
// can be used with a CodableStore 👌
let codableStore = CodableStore<User>()
```

### Observation

In order to retrieve callbacks when a certain object has been saved or deleted in a Container you can make use of the aforementioned `observe` functions. When you invoke the `oberserve` API you will retrieve a `ObserverableCodableStoreSubscription` in order to unsubscribe and avoid memory leaks.

```swift
// Initialize a CodableStore
let codableStore = CodableStore<User>()

// Observe save and delete of Users where lastName contains "Robot"
let subscription = codableStore.observe(where: { $0.lastName.contains("Robot") }) { event in
    switch event {
    case .saved(object: let object, container: let container, engine: let engine):
        break
    case .deleted(object: let object, container: let container, engine: let engine):
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
        // Observe all Users and dispose it by SubscriptionBag
        User.observeCollection { event in
            print(event)
        }.disposed(
            // Automatically unsubscribe on deinit
            by: self. subscriptionBag
        )
    }

}

```

### Access-Control

In default a `CodableStore` enables you to access all functions to write, read, observe and copy data. If you wish to use a `CodableStore` in write-only or read-only mode you can make use of the `ACL` properties.

```swift
let codableStore = CodableStore<User>()

// Write-Only CodableStore
let writeableCodableStore = codableStore.writeable

// Read-Only CodableStore
let readableCodableStore = codableStore.readable

// Observe-Only CodableStore
let observableCodableStore = codableStore.observable

// Copy-Only CodableStore
let copyableCodableStore = codableStore.copyable
```

### CodableStoreController
A `CodableStoreController` is available in three variants `CodableStoreViewController`, `CodableStoreTableViewController` and `CodableStoreCollectionViewController`. The Controllers automatically observe the Collection type you pass to generic interface like `<User>` and will call the two lifecycle functions `codableStoreablesWillUpdate` and `codableStoreablesDidUpdate`. Accessing `self.codableStoreables` will return the whole Collection of the specific type. Furthermore, the Observation will be disposed as soon as the Controller gets deallocated.

```swift
class UserListViewController: CodableStoreViewController<User> {
    
    /// Map Users to firstName list
    let toFirstNames: ([User]) -> String = {
        $0.map { $0.firstName }.joined(separator: "\n")
    }

    /// The Label to display all Users firstname
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = self.toFirstNames(self.codableStoreables)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    /// Replace View with Label
    override func loadView() {
        self.view = self.label
    }
    
    /// Did updated Users
    func codableStoreablesDidUpdate(event: CodableStore<User>.ObserveEvent,
                                    codableStoreables: [User]) {
        self.label.text = self.toFirstNames(codableStoreables)
    }
    
}
```
> Example Code to display all Users first name in UILabel and updates automatically on changes

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
