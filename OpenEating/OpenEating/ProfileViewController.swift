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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
