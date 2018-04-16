//
//  AppCoordinator.swift
//  TwitSplit
//

import UIKit

class AppCoordinator {
    static let shared = AppCoordinator()
    
    var rootNavigationController: UINavigationController!
    
    // Setup initial navigator
    func setup() {
        // Keep reference to Root NavigationController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
            self.rootNavigationController = navigationController
        }
        
        self.rootNavigationController.isNavigationBarHidden = true
        
        if let homeViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.rootNavigationController.setViewControllers([homeViewController], animated: false)
        }
    }
}
