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
    @IBOutlet weak var commentText: UITextField!
    
    var recipeID = 0
    var image = UIImage()
    var name = ""
    
    var favoritesArray: [Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsTableView: UITableView!
    
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
    var comments: [String] = []
    
    
    var theImageCache: [UIImage] = []
    var recipeResults: [Recipe] = []
    var similarResults: [SimilarRecipe] = []
    
    //    https://api.spoonacular.com/recipes/{recipe_id}/similar
    struct APIResults:Decodable {
        let results: [SimilarRecipe]
    }
    
    //    have to go through and fetch all the recipes
    struct SimilarRecipe: Decodable {
        let id: Int?
        let title: String?
        let imageType: String?
    }
    
    struct Recipe: Decodable {
        let id: Int?
        let image: String?
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        recipeImage.image = image
        getRecipeInformation()
        
        getInitComments()
    }
    
    
    func getRecipeInformation(){
        let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/information?apiKey=174a30c36e1e448a85cdee1d897b0632"
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
        print("COMMENTS COUNT: \(comments.count)")
        if(tableView == self.tableView){
            return ingredients.count
        }
        else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tableView){
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ingredientCell")
            cell.textLabel?.text = ingredients[indexPath.row].original
            return cell
        }
        else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "commentCell")
            cell.textLabel?.text = comments[indexPath.row]
            return cell
        }
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
        
        if favoritesArray.contains(recipeID){
            let index = favoritesArray.firstIndex(of: recipeID)
            favoritesArray.remove(at: index!)
        }
        else{
            self.favoritesArray.append(self.recipeID)
        }
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
                let document = querySnapshot!.documents[0]
                let data = document.data()
                self.favoritesArray = data["favorites"] as? [Int] ?? []
            }
        }
    }
    
    func setFavorites () {
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        let docRef = db.collection("users").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            if let err = err
            { print("Error getting documents: \(err)") }
            else {
                let document = querySnapshot!.documents[0]
                document.reference.updateData(["favorites":self.favoritesArray]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            
        }
    }
    
    
    
    
    func getSimilarRecipes(){
        let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/similar?apiKey=61de2798dcdc47c88f2279d7c23dad64"
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let theData = try? JSONDecoder().decode(APIResults.self, from: data) else {
            print("error")
            return }
        similarResults = theData.results
        
        getSimilarRecipeImages()
    }
    
    func getSimilarRecipeImages(){
        
        for recipe in similarResults {
            let urlPath = "https://api.spoonacular.com/recipes/"+String(recipe.id ?? 0)+"/information?apiKey=61de2798dcdc47c88f2279d7c23dad64"
            //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theRecipe = try? JSONDecoder().decode(Recipe.self, from: data) else {
                print("error")
                return
            }
            
            let imagePath = theRecipe.image ?? ""
            guard let imageUrl = URL(string: imagePath) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            guard let image = UIImage(data: imageData) else { return }
            theImageCache.append(image)
        }
    }
    
    
    
    
    @IBAction func addComment(_ sender: Any) {
        let comment = commentText.text ?? ""
        
        if(comment != ""){
            let commentToPost = "\(name): \(comment)"
            
            
            let docRef = db.collection("comments").whereField("id", isEqualTo: recipeID).getDocuments()
            {
                (querySnapshot, err) in
                
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    if(querySnapshot!.documents.count == 0)
                    {
                        //add document
                        self.addDocument(commentToPost: commentToPost)
                    }
                    else {
                        //append
                        var comments = querySnapshot!.documents[0].data()["comments"]
                        self.updateDocument(comments: comments as! [String], commentToPost: commentToPost)
                    }
                }
            }
        }
        
        
    }
    
    func getInitComments(){
        let docRef = db.collection("comments").whereField("id", isEqualTo: recipeID).getDocuments()
        {
            (querySnapshot, err) in
            
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                if(querySnapshot!.documents.count != 0)
                {
                    //add document
                    self.comments = querySnapshot!.documents[0].data()["comments"] as? [String] ?? []
                    self.displayComments()
                }
                else {
                    //append
                    print("No comments!")
                }
            }
        }
    }
    
    func addDocument(commentToPost: String)
    {
        let data: [String: Any?] = ["id":recipeID, "comments":[commentToPost]]
        
        comments = [commentToPost]
        
        db.collection("comments").document(String(recipeID) ?? "").setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.displayComments()
            }
        }
    }
    
    func updateDocument(comments: [String], commentToPost: String)
    {
        var commentUpdate = comments
        commentUpdate.append(commentToPost)
        
        self.comments = commentUpdate
        
        let data: [String: Any?] = ["id":recipeID, "comments":commentUpdate]
        db.collection("comments").document(String(recipeID) ?? "").setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.displayComments()
            }
        }
        
    }
    
    func displayComments()
    {
        commentText.text = ""
        commentsTableView.reloadData()
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


