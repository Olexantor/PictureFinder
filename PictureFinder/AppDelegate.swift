//
//  AppDelegate.swift
//  PictureFinder
//
//  Created by Александр on 13.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let manyPicturesViewController = ManyPicturesViewController(collectionViewLayout: flowLayout)
                                                                    
        window?.rootViewController = UINavigationController(
            rootViewController: manyPicturesViewController
        )
        return true
    }
}

