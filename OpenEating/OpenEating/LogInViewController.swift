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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        print("------SIGNING IN------")
        
    }
    
    @IBAction func clickSignIn(_ sender: UIButton) {
//        performSegue(withIdentifier: "SignInToHome", sender: UIButton.self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        performSegue(withIdentifier: "SignInToWelcome", sender: UIButton.self)
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
