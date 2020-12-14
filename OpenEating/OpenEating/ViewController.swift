//
//  ViewController.swift
//  OpenEating
//
//  Created by Olivia Schotz on 11/17/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    //api website: https://spoonacular.com/food-api
    //api documentation: https://spoonacular.com/food-api/docs
    //example: https://api.spoonacular.com/recipes/716429/information?apiKey=61de2798dcdc47c88f2279d7c23dad64&includeNutrition=true
    let api_key = "52a8b2f02a4a4dc587d826e60058b56a"
    
    var foodPreference: Bool = true
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    var loggedIn: Bool?
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToProfileSetup", sender: UIButton.self)
    }
    @IBAction func clickSignIn(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToSignIn", sender: UIButton.self)
    }

    func checkIfLoggedIn() {
        if Auth.auth().currentUser != nil { //add in an or to check regular log in
          // User is signed in.
            print("user signed in")
            loggedIn = true
        } else {
          // No user is signed in.
            print("there is no user signed in")
            loggedIn = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WelcomeToHome" {
            print("switching to home screen")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        // Do any additional setup after loading the view.
        if (loggedIn ?? false) != true {
            print("not logged in")
        }
        else {
            print("user already logged in")
            performSegue(withIdentifier: "WelcomeToHome", sender: self)
        }


//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()

        // instead of 'userPreferences,' this will later be the user-specific document within the users collection that stores their preferences
        docRef = Firestore.firestore().document("users/userPreferences")

    }
    
    
    // This is a function that saves data to an existing document with field/key vegeterian and value bool
//    @IBAction func saveData(_ sender: Any) {
//
//        let dataToSave: [String: Bool] = ["vegeterian": foodPreference]
//        docRef.setData(dataToSave) { (error) in
//            if error != nil {
//                print("error")
//            } else {
//                print("congrats")
//            }
//
//            self.addDocument()
//    }
//
//    }
    
    
    // This is a function that changes the food preference to be saved from true to false, it is based on the functionality of a switch but could be changed for whatever button we use to indicate preferences
//    @IBAction func vegeterianChanger(_ sender: Any) {
//
//        if vegeterianSwitch.isOn == true {
//            // person is a vegeterian
//            foodPreference = true
//            print("you are a vegeterian")
//        } else {
//            // person is not a vegeterian
//            foodPreference = false
//            print("you are not a vegeterian")
//            }
//
//    }
    
    
    // This is a function that adds a document to the users collection of documents, need to change some parts of the functionality of this since it is just a generic one
//    private func addDocument() {
//        // [START add_document]
//        // Add a new document with a generated id.
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "name": "Tokyo",
//            "country": "Japan"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//        // [END add_document]
//    }



}

