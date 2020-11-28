//
//  LogInViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/28/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickSignIn(_ sender: UIButton) {
        performSegue(withIdentifier: "SignInToHome", sender: UIButton.self)
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        performSegue(withIdentifier: "SignInToWelcome", sender: UIButton.self)
    }
    
    @IBAction func clickSignInGoogle(_ sender: UIButton) {
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
