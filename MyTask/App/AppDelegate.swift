//
//  AppDelegate.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var taskDataStore: TaskDataStore = {
        do {
            return try DataStore()
        } catch {
            return NullStore()
        }
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//            self.window = UIWindow()
//            let viewController = TasksViewController()
//            let navigationController = UINavigationController(rootViewController: viewController)
//            
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
            return true
    }
}
