//
//  AuthManagerEnvironmentKey.swift
//  Moview
//
//  Created by 심관혁 on 9/23/24.
//

import Foundation
import SwiftUI

public struct AuthManagerEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static let defaultValue: AuthManager = AuthManager(configuration: .mock(.signInAndOut))
}

public struct FirestoreManagerEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static let defaultValue: FirestoreManager = FirestoreManager()
}

public extension EnvironmentValues {
    var auth: AuthManager {
        get { self[AuthManagerEnvironmentKey.self] }
        set { self[AuthManagerEnvironmentKey.self] = newValue }
    }
    
    var db: FirestoreManager {
        get { self[FirestoreManagerEnvironmentKey.self] }
        set { self[FirestoreManagerEnvironmentKey.self] = newValue }
    }
}
