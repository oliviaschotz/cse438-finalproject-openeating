//
//  DietaryPrefsViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase

class DietaryPrefsViewController: UIViewController {
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    var documentID = ""
    
    // Food Preference Buttons
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
    var preferences: [String:Any] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addButtons()
        initButtonsStyle()
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
            btn.layer.borderWidth = 2.0
            btn.layer.borderColor = UIColor.black.cgColor
        }

        for b in buttons {
            preferences[b.accessibilityIdentifier ?? ""] = false
        }
    }
    
    
    private func addDocument() {
        
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        preferences["name"] = info["name"]
        preferences["email"] = email 
        db.collection("users").document(email ?? "").setData(preferences) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    @IBAction func clickPref(_ sender: UIButton) {
        
        preferences[sender.accessibilityIdentifier ?? ""] = !(preferences[sender.accessibilityIdentifier ?? ""] as? Bool ?? true)
        
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
    

    
    @IBAction func clickNext(_ sender: UIButton) {
        self.addDocument()
        performSegue(withIdentifier: "PrefsToMain", sender: UIButton.self)
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

