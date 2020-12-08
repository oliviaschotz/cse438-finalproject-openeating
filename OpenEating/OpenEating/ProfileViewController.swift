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
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    @IBOutlet weak var vegtButton: UIButton!
    @IBOutlet weak var vegnButton: UIButton!
    @IBOutlet weak var ketoButton: UIButton!
    @IBOutlet weak var pescButton: UIButton!
    @IBOutlet weak var paleoButton: UIButton!
    @IBOutlet weak var dairyButton: UIButton!
    @IBOutlet weak var eggButton: UIButton!
    @IBOutlet weak var glutenButton: UIButton!
    @IBOutlet weak var peanutButton: UIButton!
    @IBOutlet weak var sesameButton: UIButton!
    @IBOutlet weak var shellfishButton: UIButton!
    @IBOutlet weak var soyButton: UIButton!
    @IBOutlet weak var treenutButton: UIButton!
    

    
    var buttons: [UIButton] = []
    var preferences: [String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getPreferences()
        addButtons()
        initButtonsStyle()
    }
    
    func getPreferences() {
        // get document id and fetch preferences like in home view controller
    }
    
    func addButtons() {
       buttons.append(vegtButton)
       buttons.append(vegnButton)
       buttons.append(ketoButton)
       buttons.append(pescButton)
       buttons.append(paleoButton)
       buttons.append(dairyButton)
       buttons.append(eggButton)
       buttons.append(glutenButton)
       buttons.append(peanutButton)
       buttons.append(sesameButton)
       buttons.append(shellfishButton)
       buttons.append(soyButton)
       buttons.append(treenutButton)
   }
   
   func initButtonsStyle() {
    
    for btn in buttons {
        let isSet = preferences[btn.accessibilityIdentifier ?? ""] ?? false
        if(isSet){
            btn.backgroundColor = UIColor(named: "darkGreen") ?? UIColor.black
            btn.layer.borderColor = UIColor(named: "darkGreen")?.cgColor ?? UIColor.black.cgColor
        }
        else {
            btn.layer.borderWidth = 2.0
            btn.layer.borderColor = UIColor.black.cgColor
        }
    }
    
   }
    
    @IBAction func clickPref(_ sender: UIButton) {
           
       preferences[sender.accessibilityIdentifier ?? ""] = !(preferences[sender.accessibilityIdentifier ?? ""] ?? true)
       
       if(sender.backgroundColor == UIColor(named: "darkGreen")){
           sender.layer.borderWidth = 2.0
           sender.layer.borderColor = UIColor.black.cgColor
           sender.backgroundColor = UIColor.clear
       }
       else{
           sender.backgroundColor = UIColor(named: "darkGreen") ?? UIColor.black
           sender.layer.borderColor = UIColor(named: "darkGreen")?.cgColor ?? UIColor.black.cgColor
       }
   }
    
    @IBAction func saveChanges(_ sender: Any) {
        
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
    
//    func goHome() {
//        let tabBarVC = self.tabBarController
//        tabBarVC?.selectedIndex = 0
//    }
    
    @IBAction func logOutAcct(_ sender: UIButton) {
        print("logging out")
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("successfully logged out")
        }
        catch let signOutError as NSError{
            print("error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "LogOutToWelcome", sender: self)
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
