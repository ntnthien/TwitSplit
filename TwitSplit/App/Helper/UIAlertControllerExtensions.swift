//
//  UIAlertControllerExtensions.swift
//  TwitSplit
//

import UIKit

public typealias ActionHandler = (_ action: UIAlertAction) -> ()
public typealias AttributedActionTitle = (title: String, style: UIAlertActionStyle)

public extension UIAlertController {
    
    // Support Present UIAlertController from anywhere. It will be presented by Top Presented ViewController.
    public class func present(style: UIAlertControllerStyle = .alert, title: String?, message: String?, actionTitles: [String]?, handler: ActionHandler? = nil) {
        // Force unwrap rootViewController
        let rootViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        
        self.presentFromViewController(viewController: rootViewController, style: style, title: title, message: message, actionTitles: actionTitles, handler: handler)
    }
    
    public class func present(style: UIAlertControllerStyle = .alert, title: String?, message: String?, attributedActionTitles: [AttributedActionTitle]?, handler: ActionHandler? = nil){
        // Force unwrap rootViewController
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController!
        
        
        self.presentFromViewController(viewController: rootViewController!, style: style, title: title, message: message, attributedActionTitles: attributedActionTitles, handler: handler)
    }
    
    // Simple class method to present UIAlertController with Default UIAlertAction
    public class func presentFromViewController(viewController: UIViewController, style: UIAlertControllerStyle = .alert, title: String?, message: String?, actionTitles: [String]?, handler: ActionHandler? = nil) {
        self.presentFromViewController(viewController: viewController, style: style, title: title, message: message, attributedActionTitles: actionTitles?.map({ (title) -> AttributedActionTitle in return (title: title, style: .default) }), handler: handler)
    }
    
    // Generic class method to present UIAlertController
    public class func presentFromViewController(viewController: UIViewController, style: UIAlertControllerStyle = .alert, title: String?, message: String?, attributedActionTitles: [AttributedActionTitle]?, handler: ActionHandler? = nil) {
        // Create an instance of UIALertViewController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        // Loop all attributedActionTitles, create an UIAlertAction for each
        // attributedButtonTitles is array of tuple AttributedActionTitle
        if let _attributedActionTitles = attributedActionTitles {
            for _attributedActionTitle in _attributedActionTitles {
                let buttonAction = UIAlertAction(title: _attributedActionTitle.title, style: _attributedActionTitle.style, handler: { (action) -> Void in
                    handler?(action)
                })
                alertController.addAction(buttonAction)
            }
        }
        
        // It's fixed for case viewController is not presented viewcontroller
        viewController.topMostViewController?.present(alertController, animated: true) {}
    }
}

public extension UIViewController {
    public func presentAlert(style: UIAlertControllerStyle = .alert, title: String?, message: String?, actionTitles: [String]?, handler: ActionHandler? = nil) {
        UIAlertController.presentFromViewController(viewController: self, style: style, title: title, message: message, actionTitles: actionTitles, handler: handler)
    }
    
    public func presentAlert(style: UIAlertControllerStyle = .alert, title: String?, message: String?, attributedActionTitles: [AttributedActionTitle]?, handler: ActionHandler? = nil) {
        UIAlertController.presentFromViewController(viewController: self, style: style, title: title, message: message, attributedActionTitles: attributedActionTitles, handler: handler)
    }
    
    // Get ViewController in top present level
    internal var topPresentedViewController: UIViewController? {
        get {
            var target: UIViewController? = self
            while (target?.presentedViewController != nil) {
                target = target?.presentedViewController
            }
            return target
        }
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be topViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarContrller instance
    internal var topVisibleViewController: UIViewController? {
        get {
            if let nav = self as? UINavigationController {
                return nav.topViewController?.topVisibleViewController
            }
            else if let tabBar = self as? UITabBarController {
                return tabBar.selectedViewController?.topVisibleViewController
            }
            return self
        }
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    internal var topMostViewController: UIViewController? {
        get {
            return self.topPresentedViewController?.topVisibleViewController
        }
    }
}
