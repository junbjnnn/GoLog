//
//  DebugMenu.swift
//  XLog
//
//  Created by NamDV on 8/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class DebugMenu {
    
    public static let shared = DebugMenu()
    
    private init() {}
    
    public var enable = false {
        didSet {
            if enable {
                DebugMenu.shared.addDebugMenu()
            } else {
                DebugMenu.shared.removeDebugMenu()
            }
        }
    }
    
    var devButton: DebugMenuButton? {
        // TODO: Make config root screen
        // let window = UIApplication.shared.delegate?.window as? UIWindow
        let window = UIApplication.shared.keyWindow

        var devButton = window?.viewWithTag(DebugMenuButton.devButtonTag) as? DebugMenuButton
        let isReady = window == devButton?.superview
        if !isReady {
            devButton = DebugMenuButton.devButton()
            devButton?.addTarget(self, action: #selector(devButtonDidTap(_:)), for: .touchUpInside)
            if let devButton = devButton {
                window?.addSubview(devButton)
            }
        }
        return devButton
    }
    
    func addDebugMenu() {
        let devButton = self.devButton
        if let devButton = devButton {
            devButton.superview?.bringSubviewToFront(devButton)
            devButton.addTarget(self, action: #selector(devButtonDidTap(_:)), for: .touchUpInside)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(windowDidBecomeVisible(_:)),
                name: UIWindow.didBecomeVisibleNotification,
                object: nil
            )
        }
    }
    
    func removeDebugMenu() {
        self.devButton?.removeFromSuperview()
    }
    
    @objc
    func windowDidBecomeVisible(_ notification: Notification?) {
        let devButton = self.devButton
        if let devButton = devButton {
            devButton.superview?.bringSubviewToFront(devButton)
            devButton.addTarget(self, action: #selector(devButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc
    func devButtonDidTap(_ button: DebugMenuButton?) {
        if let tappable = button?.tappable, tappable {
            present(DebugMenuViewController())
        }
    }
    
    func present(_ controller: UIViewController?) {
        let navigationController = UINavigationController()
        if let controller = controller {
            navigationController.pushViewController(controller, animated: false)
        }
        controller?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closePresentedViewController(_:)))
        navigationController.modalPresentationStyle = .fullScreen
        
        let viewController = getVisibleViewController(nil)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as? UINavigationController
                return navigationController?.viewControllers.last
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as? UITabBarController
                return tabBarController?.selectedViewController
            }

            return getVisibleViewController(presented)
        }
        return nil
    }
    
    @objc
    func closePresentedViewController(_ sender: Any?) {
        getVisibleViewController(nil)?.dismiss(animated: true) {
            self.devButton?.isHidden = false
        }
    }
    
}
