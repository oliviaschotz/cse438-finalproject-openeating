//
//  LogInViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/28/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController {
   
    var userEmail: String = ""
    var handle: AuthStateDidChangeListenerHandle?
    var loggedIn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        print("------SIGNING IN------")
        
//        checkLogInStat()
    }
//    func checkLogInStat() {
//        while (loggedIn ?? false) != true {
//            if Auth.auth().currentUser != nil { //add in an or to check regular log in
//              // User is signed in.
//                print("user signed in")
//                loggedIn = true
//                performSegue(withIdentifier: "SignInToHome", sender: self)
//            } else {
//              // No user is signed in.
//                loggedIn = false
//            }
//        }
//    }
    
//    func toHome() {
//        loggedIn = true
//        performSegue(withIdentifier: "SignInToHome", sender: self)
//    }
    
    func checkLogInStatus() {
        if Auth.auth().currentUser != nil { //add in an or to check regular log in
            // User is signed in.
            print("user signed in")
            loggedIn = true
            performSegue(withIdentifier: "SignInToHome", sender: self)
        }
        else {
            // No user is signed in.
            loggedIn = false
        }
    }
    
    @IBAction func clickSignIn(_ sender: UIButton) {
        checkLogInStatus()
        if (loggedIn ?? false) == true {
            performSegue(withIdentifier: "SignInToHome", sender: UIButton.self)
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Please log in or create an account to access OpenEating", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        //check if signed in...if not have error message pop up
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
