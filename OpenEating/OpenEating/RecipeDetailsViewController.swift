//
//  RecipeDetailsViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase

class RecipeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTags: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var shareButton: UIImageView!
    
    var recipeID = 0
    var image = UIImage()
    
    var favoritesArray: [Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    struct DetailedRecipe: Decodable {
        let id: Int?
        let title: String?
        let servings: Int?
        let readyInMinutes: Int?
        let sourceName: String?
        let sourceURL: String?
        let aggregateLikes: Int?
        let healthScore: Int?
        let cuisines: [String]?
        let instructions: String?
        let dishTypes: [String]?
        let extendedIngredients: [Ingredient]?
        let summary: String?
    }

    
    struct Ingredient: Decodable {
        let id: Int?
        let original: String?
    }
    
    var ingredients: [Ingredient] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        recipeImage.image = image
        getRecipeInformation()
    }
    

    func getRecipeInformation(){
        let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/information?apiKey=61de2798dcdc47c88f2279d7c23dad64"
        //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let theRecipe = try? JSONDecoder().decode(DetailedRecipe.self, from: data) else {
            print("error")
            return
        }
        
        recipeName.text = theRecipe.title
        numLikes.text = String(describing: theRecipe.aggregateLikes!)
        
        recipeID = theRecipe.id ?? 0
        
        summary.text = parseHTML(str: theRecipe.summary)
        instructions.text = parseHTML(str: theRecipe.instructions)
        
        ingredients = theRecipe.extendedIngredients ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ingredientCell")
        cell.textLabel?.text = ingredients[indexPath.row].original
        return cell
    }
    
//    for creating/using regex in swift: https://medium.com/@dkw5877/regular-expressions-in-swift-928561ad55c8
    func parseHTML(str:String?) -> String? {
        let pattern = "<[^\\r\\n\\>]+>"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let parsedStr = regex.stringByReplacingMatches(in: str ?? "", options: [], range: NSRange(location: 0, length: str?.count ?? 0), withTemplate: " ") as NSString

        return parsedStr as String?
    }
    
    @IBAction func shareRecipe(_ sender: Any) {
        var ingredientsList: String = ""
        for ingredient in ingredients {
            // don't force unwrap this
            ingredientsList = ingredientsList + ", " + ingredient.original!
        }
        print("\(ingredientsList)")
        
        // need to figure out how to get ingredients as a string since they are in an array currently
        let recipeInfo: [String?] = [recipeName.text, summary.text, instructions.text]
        let ac = UIActivityViewController(activityItems: recipeInfo, applicationActivities: [])
        present(ac, animated: true)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        favoritesArray = []
        
        getFavorites()
        
        favoritesArray.append(recipeID)
        
        setFavorites()
    }
    
    func getFavorites () {
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        let docRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
                if let err = err
                    { print("Error getting documents: \(err)") }
                else
                {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        var data = document.data()
//                        var favorites = data.favorites
//                        for favorite in favorites {
//                            favoritesArray.append(favorite)
//                        }
                    }
                }
        }
    }
    
    func setFavorites () {
        
        
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
