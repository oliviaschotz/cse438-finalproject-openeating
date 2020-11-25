//
//  DietaryPrefsViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class DietaryPrefsViewController: UIViewController {
    
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
    //another array or two to actually save the data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        initButtonsStyle()
        // Do any additional setup after loading the view.
    }
    
    func addButtons() {
        buttons.append(vegnButton)
        buttons.append(vegtButton)
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
    }
       
    func clickedStyle(button: UIButton) {
           if button.isEnabled {
               button.backgroundColor = UIColor(named: "darkGreen") ?? UIColor.black
               button.layer.borderColor = UIColor(named: "darkGreen")?.cgColor ?? UIColor.black.cgColor
           }
           else {
               button.layer.borderWidth = 2.0
               button.layer.borderColor = UIColor.black.cgColor
           }
    }
    
    @IBAction func clickVegt(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickVegn(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickKeto(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickPesc(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickPaleo(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickDairy(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickEgg(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickGluten(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickPeanut(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickSesame(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickShellfish(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickSoy(_ sender: UIButton) {
        clickedStyle(button: sender)
        //something else to save the data
    }
    
    @IBAction func clickTreenut(_ sender: UIButton) {
        clickedStyle(button: sender)
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
