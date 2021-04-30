//
//  WritableCodableStoreProtocol.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 02.04.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - WritableCodableStoreProtocol

/// The WritableCodableStoreProtocol
public typealias WritableCodableStoreProtocol = SaveableCodableStoreProtocol & DeletableCodableStoreProtocol
