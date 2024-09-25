//
//  UIApplication+Extension.swift
//  Moview
//
//  Created by 심관혁 on 9/23/24.
//

import Foundation
import UIKit

extension UIApplication {
    
    static private func rootViewController() -> UIViewController? {
        var rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?
                .rootViewController
        } else {
            rootVC = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }?
                .rootViewController
        }
        // UIApplication.shared.keyWindow?.rootViewController -> iOS 13 error
        // UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController -> iOS 15 error
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return rootVC ?? window?.windowScene?.keyWindow?.rootViewController
    }
    
    @MainActor static func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? rootViewController()
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
