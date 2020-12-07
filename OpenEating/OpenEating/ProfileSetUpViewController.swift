//
//  ProfileSetUpViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileSetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        HOW DO WE FORCE ORDER OF THESE CALLS?
        GIDSignIn.sharedInstance().signIn()
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
            print("user signed in")
            self.performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: self)
        } else {
          // No user is signed in.
          print("there is no user signed in")
        }
    }
    
    
    
    @IBAction func clickCreateAcct(_ sender: UIButton) {
        performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: UIButton.self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
