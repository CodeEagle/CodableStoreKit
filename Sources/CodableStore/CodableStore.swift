//
//  CodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 20.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStore

/// The CodableStore
public struct CodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The Container
    public let container: CodableStoreContainer
    
    /// The CodableStoreNotificationCenter
    let notificationCenter: CodableStoreNotificationCenter
    
    /// The FileManager
    let fileManager: FileManager
    
    /// The Encoder
    let encoder: AnyEncoder
    
    /// The Decoder
    let decoder: AnyDecoder
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - container: The Container. Default value `.default`
    ///   - notificationCenter: The CodableStoreNotificationCenter. Default value `.default`
    ///   - fileManager: The FileManager. Default value `.default`
    ///   - encoder: The Encoder. Default value `JSONEncoder()`
    ///   - decoder: The Decoder. Default value `JSONDecoder()`
    public init(
        container: CodableStoreContainer = .default,
        notificationCenter: CodableStoreNotificationCenter = .default,
        fileManager: FileManager = .default,
        encoder: AnyEncoder = JSONEncoder(),
        decoder: AnyDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
        self.notificationCenter = notificationCenter
        self.container = container
    }
    
}

// MARK: - CustomStringConvertible

extension CodableStore: CustomStringConvertible {
    
    /// A textual representation of this instance
    public var description: String {
        let storableType = String(
            describing: Mirror(reflecting: Storable.self).subjectType
        ).replacingOccurrences(of: ".Type", with: "")
        return """
        CodableStore<\(storableType)>
        Container: \(self.container.name)
        Collection: \(Storable.codableStoreCollectionName)
        File-System-URL: \((try? self.collectionURL().get())?.absoluteString ?? "n.a.")
        """
    }
    
}

// MARK: - Equatable

extension CodableStore: Equatable {
    
    /// Returns a Boolean value indicating whether two CodableStores are equal.
    ///
    /// - Parameters:
    ///   - lhs: A CodableStore to compare.
    ///   - rhs: Another CodableStore to compare.
    public static func == (
        lhs: CodableStore<Storable>,
        rhs: CodableStore<Storable>
    ) -> Bool {
        lhs.fileManager === rhs.fileManager
            && lhs.notificationCenter === rhs.notificationCenter
            && lhs.container == rhs.container
    }
    
}
