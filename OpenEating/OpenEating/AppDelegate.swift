//
//  AppDelegate.swift
//  OpenEating
//
//  Created by Olivia Schotz on 11/17/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            // check if document for this user already exists, make new document for each new user
            // Get user email
            //currentUser(firstName: user.profile.givenName, lastName: user.profile.familyName, userEmail: user.profile.email)
            let currentUser = User(name: (user.profile.givenName ?? "No Name") + " " + (user.profile.familyName ?? "No Name"), userEmail: user.profile.email ?? "No Email")
            
            let userInfo = ["name": currentUser.name, "email": currentUser.userEmail]
            
            UserDefaults.standard.set(userInfo, forKey: "userInfo")
            
            UserDefaults.standard.set(currentUser.userEmail, forKey: "email")
            
            
            
            // Make user authentication and credentials
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            print("authentication is \(authentication)")
            print("credential is \(credential)")
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("authentication error \(error.localizedDescription)")
                }
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in

            // Handle authenticated state
        }
        //        self.inputViewController?.performSegue(withIdentifier: "SignInToHome", sender: self)

          // Handle authenticated state
          

    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // "671555113764-9splhvfee8j5h460k63du7hjnutiuh82.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        let db = Firestore.firestore()
        print(db)
        
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
}
