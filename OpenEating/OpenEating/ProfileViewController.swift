//
//  ProfileViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/19/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

//extension UIApplication {
//    func tabBarController() -> UIViewController? {
//        guard let vcs = self.keyWindow?.rootViewController?.children else { return nil }
//        for vc in vcs {
//            if let _ = vc as? UITabBarController {
//                return vc
//            }
//        }
//        
//        return nil
//    }
//}

class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            print("error signing out: %@", signOutError)
        }
    }
    @IBAction func logOutAcct(_ sender: UIButton) {
//        print("logging out")
//        let firebaseAuth = Auth.auth()
//        do{
//            try firebaseAuth.signOut()
//            print("successfully logged out")
//        }
//        catch let signOutError as NSError{
//            print("error signing out: %@", signOutError)
//        }
//        guard let tabBarController = UIApplication.shared.tabBarController() as? UITabBarController else { return }
//        
//        tabBarController.selectedIndex = 0
    }
    
//    db.collection("users").document("userPreferences").setData(preferences)
//        { err in
//        if let err = err {
//            print("Error writing document: \(err)")
//        } else {
//            print("Document successfully written!")
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
