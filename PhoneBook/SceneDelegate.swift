//
//  SceneDelegate.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 20.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        configureNaviationBar()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootVC = MainViewController()
        let navContr = UINavigationController(rootViewController: rootVC)
        
        window.rootViewController = navContr
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func configureNaviationBar() {
        // UINavigationBar
        UIBarButtonItem.appearance().tintColor = .black
//        let navigationBarAppearance = UINavigationBar.appearance()
//        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
//        let navigationBarStandartAppearance = UINavigationBarAppearance()
//        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationBarStandartAppearance.configureWithOpaqueBackground()
//        navigationBarStandartAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
////        navigationBarStandartAppearance.titleTextAttributes = [.foregroundColor: Asset.Colors.black.color, .font: FontFamily.Roboto.medium.font(size: 16)]
////        navigationBarStandartAppearance.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.black.color, .font: FontFamily.Roboto.medium.font(size: 24)]
//        navigationBarStandartAppearance.shadowColor = .clear
//        navigationBarStandartAppearance.backButtonAppearance = buttonAppearance
//        navigationBarStandartAppearance.buttonAppearance = buttonAppearance
//        if #available(iOS 15.0, *) {
//            navigationBarStandartAppearance.backgroundColor = . white
//        }
//        navigationBarAppearance.standardAppearance = navigationBarStandartAppearance
//        navigationBarAppearance.isTranslucent = true
//        navigationBarAppearance.prefersLargeTitles = true
    }

}

