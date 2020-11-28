//
//  ProfileSetUpViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class ProfileSetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickCreateAcct(_ sender: UIButton) {
        performSegue(withIdentifier: "ProfSUToDietaryPrefs", sender: UIButton.self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
