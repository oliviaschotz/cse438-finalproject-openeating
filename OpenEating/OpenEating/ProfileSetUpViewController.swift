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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
//        HOW DO WE FORCE ORDER OF THESE CALLS?
    }
    
    
    
    
    @IBAction func clickCreateAcct(_ sender: UIButton) {
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        let docRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments()
        {
            
            (querySnapshot, err) in
            
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    if(querySnapshot!.documents.count > 0)
                    {
                        let alertController = UIAlertController(title: "Error", message: "You already have an account! Please log in to use OpenEating.", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated: true)
                    }
                    else {
                        self.performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: UIButton.self)
                    }
                }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
