//
//  FavoritesViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/18/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    var favoritesArray: [Int] = []
    var recipeResults: [Recipe] = []
       
    struct Recipe: Decodable {
        let title: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        getFavorites()
        fetchDataForTableView()
        
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
    
    func fetchDataForTableView(){
        for recipeID in favoritesArray{
            let urlPath = "https://api.spoonacular.com/recipes/\(recipeID)/information?includeNutrition=false" //where to put API key?
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theData = try? JSONDecoder().decode(Recipe.self, from: data) else {
                print("error")
                return }
            recipeResults.append(theData)
        }
        
    }
    
    func getFavorites(){
            let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
            let email = info["email"]
            
            let docRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
                (querySnapshot, err) in
                    if let err = err
                        { print("Error getting documents: \(err)") }
                    else
                    {
                        let document = querySnapshot!.documents[0]
                        let data = document.data()
                        self.favoritesArray = data["favorites"] as? [Int] ?? []
                    }
            }
        }
    

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavCell
        cell.recipeName.text = recipeResults[indexPath.row].title
        return cell
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

