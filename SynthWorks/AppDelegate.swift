//
//  AppDelegate.swift
//  SynthWorks
//
//  Created by Riccardo Persello on 26/07/21.
//

import os
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, Loggable {
    var window: UIWindow?
    var currentDocument: Document?
    var currentViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        currentViewController = window?.rootViewController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        logger.info("applicationWillResignActive: trying to save current document.")

        if let currentDocument = currentDocument {
            currentDocument.save(to: currentDocument.fileURL, for: .forOverwriting, completionHandler: { success in
                if !success {
                    self.handle(DocumentError.cannotSaveBeforeResign,
                                from: (self.window?.rootViewController)!,
                                retryHandler: nil)
                }
            })
        } else {
            logger.warning("There is no current document saved in AppDelegate. Shouldn't be a problem as long as there are no open files.")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else { return false }

        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else {
            return false
        }

        documentBrowserViewController.presentDocument(at: inputURL)

        return true
    }
}
