//
//  SceneDelegate.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let mainController = MainViewController()
        let navController = UINavigationController(rootViewController: mainController)
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

