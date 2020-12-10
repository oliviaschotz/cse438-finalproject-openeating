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
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    var documentID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        HOW DO WE FORCE ORDER OF THESE CALLS?
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().signIn()
                
        print(Auth.auth().currentUser)
        let email = UserDefaults.standard.string(forKey: "email")
        print("---USER EMAIL---\(email)")
        if Auth.auth().currentUser != nil {
          // User is signed in.
            
            let userInfo = ["name": Auth.auth().currentUser?.displayName, "email": Auth.auth().currentUser?.email]
            
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: userInfo) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                else {
                    print("Logged In Document added with ID: \(ref!.documentID)")
                    self.documentID = ref!.documentID
                    UserDefaults.standard.set(self.documentID, forKey: Auth.auth().currentUser?.email ?? "")
                }
            }
            
//            self.performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: self)
        } else {
          // No user is signed in.
          print("there is no user signed in")
        }
    }
    
    
    
    @IBAction func clickCreateAcct(_ sender: UIButton) {
//        performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: UIButton.self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dietaryVC = segue.destination as? DietaryPrefsViewController
        dietaryVC?.documentID = documentID
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
