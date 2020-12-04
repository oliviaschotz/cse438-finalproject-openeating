//
//  DietaryPrefsViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

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
            // person is a vegeterian
            isVegn = true
            print("you are a vegan")
        } else {
            // person is not a vegeterian
            isVegn = false
            print("you are not a vegan")
            }
        
    }
    
    @IBAction func clickKeto(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 2)
        numClicks[2] += 1
        
        if numClicks[2] % 2 == 1 {
            // person is a vegeterian
            isKeto = true
            print("you are a keto")
        } else {
            // person is not a vegeterian
            isKeto = false
            print("you are not a keto")
            }
        
    }
    
    @IBAction func clickPesc(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 3)
        numClicks[3] += 1
        //something else to save the data
    }
    
    @IBAction func clickPaleo(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 4)
        numClicks[4] += 1
        //something else to save the data
    }
    
    @IBAction func clickDairy(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 5)
        numClicks[5] += 1
        //something else to save the data
    }
    
    @IBAction func clickEgg(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 6)
        numClicks[6] += 1
        //something else to save the data
    }
    
    @IBAction func clickGluten(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 7)
        numClicks[7] += 1
        //something else to save the data
    }
    
    @IBAction func clickPeanut(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 8)
        numClicks[8] += 1
        //something else to save the data
    }
    
    @IBAction func clickSesame(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 9)
        numClicks[9] += 1
        //something else to save the data
    }
    
    @IBAction func clickShellfish(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 10)
        numClicks[10] += 1
        //something else to save the data
    }
    
    @IBAction func clickSoy(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 11)
        numClicks[11] += 1
        //something else to save the data
    }
    
    @IBAction func clickTreenut(_ sender: UIButton) {
        clickedStyle(button: sender, loc: 12)
        numClicks[12] += 1
        //something else to save the data
    }
    
    @IBAction func clickNext(_ sender: UIButton) {
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
