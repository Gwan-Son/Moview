//
//  IsLoggedInEnvironmentKey.swift
//  Moview
//
//  Created by 심관혁 on 9/27/24.
//

import Foundation
import SwiftUI

struct IsLoggedInEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoggedIn: Binding<Bool> {
        get { self[IsLoggedInEnvironmentKey.self] }
        set { self[IsLoggedInEnvironmentKey.self] = newValue }
    }
}
