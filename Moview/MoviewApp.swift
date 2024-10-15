//
//  MoviewApp.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MoviewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var firestoreManager = FirestoreManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView()
                    .environment(\.auth, AuthManager(configuration: .firebase))
                    .environmentObject(firestoreManager)
            }
        }
    }
}
