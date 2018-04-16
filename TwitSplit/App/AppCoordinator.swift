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
        
        // Mock User Login
        UserManager.shared.login(user: User(id: UUID(), name: "Do Nguyen", avatarUrl: nil))
        
        // Navigate to HomeViewController after the user is authenticated
        if UserManager.shared.activeUser != nil, let homeViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            
            self.rootNavigationController.setViewControllers([homeViewController], animated: false)
        }
    }
}
