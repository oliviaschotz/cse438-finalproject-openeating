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
   
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    
    var documentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }

    @IBAction func clickSignIn(_ sender: UIButton) {
        
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        db.collection("users").whereField("email", isEqualTo: email as Any).getDocuments()
        {
            
            (querySnapshot, err) in
            
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    guard let queryS = querySnapshot else {
                        return
                    }
                    if(queryS.documents.count == 0)
                    {
                        let alertController = UIAlertController(title: "Error", message: "Please log in or create an account to access OpenEating", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated: true)
                    }
                    else {
                        self.performSegue(withIdentifier: "SignInToHome", sender: UIButton.self)
                    }
                }
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
