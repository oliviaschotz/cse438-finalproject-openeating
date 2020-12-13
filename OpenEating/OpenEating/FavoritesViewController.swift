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
    
    let api_key = "7b2c5999d4f940a999efad739e883d3c"
    
    var favoritesArray: [[String:Any]] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
       
//    struct Recipe: Decodable {
//        let title: String?
//        let id: Int?
//        let image: String?
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getFavorites()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTableView()
        getFavorites()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
    func getFavorites(){
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
            
        let docRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
                (querySnapshot, err) in
            if let err = err
                { print("Error getting documents: \(err)") }
            else {
                let document = querySnapshot!.documents[0]
                let data = document.data()
                self.favoritesArray = data["favorites"] as? [[String:Any]] ?? []
//                self.fetchDataForTableView()
            }
            print(self.favoritesArray)
        }
    }
    
//    func fetchDataForTableView(){
//        print("fetching data for favorites: \(favoritesArray)")
//        recipeResults = []
//        for recipeID in favoritesArray{
//            let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/information?apiKey="+api_key
//            guard let url = URL(string: urlPath) else { return  }
//            guard let data =  try?  Data(contentsOf: url) else { return }
//            guard let theData = try? JSONDecoder().decode(Recipe.self, from: data) else {
//                print("error")
//                return }
//            recipeResults.append(theData)
//            //tableView.reloadData()
//        }
//    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("table count: \(recipeResults.count)")
//        return recipeResults.count
        print("table view count \(favoritesArray.count)")
        return favoritesArray.count
     }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavCell
        //cell.recipeTags.text = ""
//        cell.recipeName.text = recipeResults[indexPath.row].title
//        print(recipeResults[indexPath.row].title)
        
        cell.recipeName.text = favoritesArray[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toRecipePage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "toRecipePage") {

            guard let indexPaths=self.tableView!.indexPathsForSelectedRows else {
                return
            }
            let indexPath = indexPaths[0] as NSIndexPath
            let selectedRecipe = favoritesArray[indexPath.row]
            
            guard let recipeVC = segue.destination as? RecipeDetailsViewController else {
                return
            }
            
            recipeVC.recipeID = selectedRecipe["id"] as! Int
            recipeVC.image = selectedRecipe["image"] as! UIImage
            //recipeVC.name = userPreferences["name"] as? String ?? ""
        }
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

