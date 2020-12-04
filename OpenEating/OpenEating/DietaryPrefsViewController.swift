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
    
    // Food Preference Variables
    var isVegt: Bool = false
    var isVegn: Bool = false
    var isKeto: Bool = false
    var isPesc: Bool = false
    var isPaleo: Bool = false
    var isDairy: Bool = false
    var isEgg: Bool = false
    var isGluten: Bool = false
    var isPeanut: Bool = false
    var isSesame: Bool = false
    var isShellFish: Bool = false
    var isSoy: Bool = false
    var isTreeNut: Bool = false
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    var buttons: [UIButton] = []
    //another array or two to actually save the data
    var numClicks: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        initButtonsStyle()
        // Do any additional setup after loading the view.
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
        for _ in buttons {
            numClicks.append(0)
        }
    }
    
    //count of clicks if odd = clicked,even = unclicked
    func clickedStyle(button: UIButton, loc: Int) {
        if numClicks[loc] % 2 == 0 {
            button.backgroundColor = UIColor(named: "darkGreen") ?? UIColor.black
            button.layer.borderColor = UIColor(named: "darkGreen")?.cgColor ?? UIColor.black.cgColor
        }
        else {
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.black.cgColor
            button.backgroundColor = UIColor.clear
        }
    }
    
    private func addDocument() {
            
            db.collection("users").document("userPreferences").setData(
                ["vegeterian": isVegt, "vegan" : isVegn, "keto" : isKeto, "pescaterian" : isPesc, "paleo" : isPaleo, "dairyFree" : isDairy, "eggFree" : isEgg, "glutenFree" : isGluten, "peanutFree" : isPeanut, "sesameFree" : isSesame, "shellfishFree" : isShellFish, "soyFree" : isSoy, "treenutFree" : isTreeNut])
                { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        
//        let dataToSave: [String: Bool] =  ["vegeterian": isVegt, "vegan" : isVegn, "keto" : isKeto, "pescaterian" : isPesc, "paleo" : isPaleo, "dairyFree" : isDairy, "eggFree" : isEgg, "glutenFree" : isGluten, "peanutFree" : isPeanut, "sesameFree" : isSesame, "shellfishFree" : isShellFish, "soyFree" : isSoy, "treenutFree" : isTreeNut]
//        docRef.setData(dataToSave) { (error) in
//            if error != nil {
//                print("error")
//            } else {
//                print("congrats")
//            }
//
//        //self.addDocument()
//
//        }

        }
    
    @IBAction func saveData(_ sender: Any) {
        
//        let dataToSave: [String: Bool] =  ["vegeterian": isVegt, "vegan" : isVegn, "keto" : isKeto, "pescaterian" : isPesc, "paleo" : isPaleo, "dairyFree" : isDairy, "eggFree" : isEgg, "glutenFree" : isGluten, "peanutFree" : isPeanut, "sesameFree" : isSesame, "shellfishFree" : isShellFish, "soyFree" : isSoy, "treenutFree" : isTreeNut]
//        docRef.setData(dataToSave) { (error) in
//            if error != nil {
//                print("error")
//            } else {
//                print("congrats")
//            }
//
//        self.addDocument()
//
//        }
    }
    
    
    @IBAction func clickVegt(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 0)
        numClicks[0] += 1
        
        if numClicks[0] % 2 == 1 {
            // person is a vegeterian
            isVegt = true
            print("you are a vegeterian")
        } else {
            // person is not a vegeterian
            isVegt = false
            print("you are not a vegeterian")
            }
        
    }
    
    @IBAction func clickVegn(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 1)
        numClicks[1] += 1
        
        if numClicks[1] % 2 == 1 {
            // person is a vegan
            isVegn = true
            print("you are a vegan")
        } else {
            // person is not a vegan
            isVegn = false
            print("you are not a vegan")
            }
        
    }
    
    @IBAction func clickKeto(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 2)
        numClicks[2] += 1
        
        if numClicks[2] % 2 == 1 {
            // person is keto
            isKeto = true
            print("you are keto")
        } else {
            // person is not keto
            isKeto = false
            print("you are not keto")
            }
        
    }
    
    @IBAction func clickPesc(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 3)
        numClicks[3] += 1
        
        if numClicks[3] % 2 == 1 {
            // person is a pescaterian
            isPesc = true
            print("you are a pescaterian")
        } else {
            // person is not a pescaterian
            isPesc = false
            print("you are not a pescaterian")
            }
        
    }
    
    @IBAction func clickPaleo(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 4)
        numClicks[4] += 1
        
        if numClicks[4] % 2 == 1 {
            // person is paleo
            isPaleo = true
            print("you are paleo")
        } else {
            // person is not paleo
            isPaleo = false
            print("you are not paleo")
            }
        
    }
    
    @IBAction func clickDairy(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 5)
        numClicks[5] += 1
        
        if numClicks[5] % 2 == 1 {
            // person is adverse to dairy
            isDairy = true
            print("you are adverse to dairy")
        } else {
            // person is not adverse to dairy
            isDairy = false
            print("you are not adverse to dairy")
            }
        
    }
    
    @IBAction func clickEgg(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 6)
        numClicks[6] += 1
        
        if numClicks[6] % 2 == 1 {
            // person is adverse to eggs
            isEgg = true
            print("you are adverse to eggs")
        } else {
            // person is not adverse to eggs
            isEgg = false
            print("you are not adverse to eggs")
            }
        
    }
    
    @IBAction func clickGluten(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 7)
        numClicks[7] += 1
        
        if numClicks[7] % 2 == 1 {
            // person is adverse to gluten
            isGluten = true
            print("you are adverse to gluten")
        } else {
            // person is not adverse to gluten
            isGluten = false
            print("you are not adverse to gluten")
            }
        
    }
    
    @IBAction func clickPeanut(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 8)
        numClicks[8] += 1
        
        if numClicks[8] % 2 == 1 {
            // person is adverse to peanuts
            isPeanut = true
            print("you are adverse to peanuts")
        } else {
            // person is not adverse to peanuts
            isPeanut = false
            print("you are not adverse to peanuts")
            }
        
    }
    
    @IBAction func clickSesame(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 9)
        numClicks[9] += 1
        
        if numClicks[9] % 2 == 1 {
            // person is adverse to sesame
            isSesame = true
            print("you are adverse to sesame")
        } else {
            // person is not adverse to sesame
            isSesame = false
            print("you are not adverse to sesame")
            }
        
    }
    
    @IBAction func clickShellfish(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 10)
        numClicks[10] += 1
        
        if numClicks[10] % 2 == 1 {
            // person is adverse to shell fish
            isShellFish = true
            print("you are adverse to shell fish")
        } else {
            // person is not adverse to shell fish
            isShellFish = false
            print("you are not adverse to shell fish")
            }
        
    }
    
    @IBAction func clickSoy(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 11)
        numClicks[11] += 1
        
        if numClicks[11] % 2 == 1 {
            // person is adverse to soy
            isSoy = true
            print("you are adverse to soy")
        } else {
            // person is not adverse to soy
            isSoy = false
            print("you are not adverse to soy")
            }
        
    }
    
    @IBAction func clickTreenut(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 12)
        numClicks[12] += 1
        
        if numClicks[12] % 2 == 1 {
            // person is adverse to tree nuts
            isTreeNut = true
            print("you are adverse to tree nuts")
        } else {
            // person is not adverse to tree nuts
            isTreeNut = false
            print("you are not adverse to tree nuts")
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

