//
//  RecipeDetailsViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class RecipeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    let api_key = "9d9dd708463f43c896abc64af541c052"
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTags: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var instructions: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    
    var recipeID = 0
    var recipeTitle: String = ""
    
    var image = UIImage()
    var name = ""
    var ingredientsList: String = ""
    
    @IBOutlet weak var favoriteButton: UIButton!
    var favoritesArray: [[String:Any]] = []
    /*favoritesArray example:
     [["name": "Chicken Caesar Salad", "id": ######, "image":"imageURL"],["name": "Mac and Cheese", "id": ######, "image":"imageURL"]]
     */
    var imageURL: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
//        how can i scroll to top of page??
        recipeImage.image = image
        getRecipeInformation()
        getInitComments()
        checkFavorite()
    }
    
    func checkFavorite(){
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        db.collection("users").whereField("email", isEqualTo: email as Any).getDocuments() {
            (querySnapshot, err) in
            if let err = err
            { print("Error getting documents: \(err)") }
            else
            {
                guard let queryS = querySnapshot else {
                    return
                } 
                let document = queryS.documents[0]
                let data = document.data()["favorites"] as? [[String:Any]] ?? []
                
                for fav in data {
                    if((fav["id"] as? Int ?? 0) == self.recipeID){
                         self.favoriteButton.setTitle("Added to Favorites", for: .normal)
                       self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                }
                
                
            }
        }
    }
    
    
    func getRecipeInformation(){
        let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/information?apiKey="+api_key
        //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let theRecipe = try? JSONDecoder().decode(DetailedRecipe.self, from: data) else {
            print("error")
            return
        }
        
        recipeName.text = theRecipe.title
        
        
        recipeTags.text = ""
        if(theRecipe.cuisines?.count ?? -1 > 0){
            recipeTags.text = theRecipe.cuisines?[0]
        }
        
        numLikes.text = String(describing: theRecipe.aggregateLikes ?? 0)
        
        recipeID = theRecipe.id ?? 0
        recipeTitle = theRecipe.title ?? ""
        
        summary.text = parseHTML(str: theRecipe.summary)
        instructions.text = parseHTML(str: theRecipe.instructions)
        if instructions.text == "" {
            instructions.text = "No instructions available"
            instructions.textColor = UIColor(named: "lightGray") ?? UIColor.gray
        }
        
        ingredients = theRecipe.extendedIngredients ?? []
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return ""
        }
        
        let parsedStr = regex.stringByReplacingMatches(in: str ?? "", options: [], range: NSRange(location: 0, length: str?.count ?? 0), withTemplate: " ") as NSString
        
        return parsedStr as String?
    }
    
    //    // This method isn't attached to anything right now
    //    // Import MFMessageComposeViewControllerDelegate into the class if you use this function
    //    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    //       if MFMessageComposeViewController.canSendText() {
    //            let composeVC = MFMessageComposeViewController()
    //            composeVC.messageComposeDelegate = self
    //
    //            // Configure the fields of the interface.
    //            composeVC.recipients = [""]
    //            composeVC.body = "\(recipeName.text ?? " ") Summary: \(summary.text ?? "No Summary") Ingredients: \(ingredientsList) Instructions: \(instructions.text ?? "No Instructions")"
    //
    //            // Present the view controller modally.
    //            self.present(composeVC, animated: true, completion: nil)
    //
    //            // dismisses the VC
    //            controller.dismiss(animated: true, completion: nil)
    //        } else {
    //            print("SMS services are not available")
    //        }
    ////     Other things, might not be useful
    ////        let smsComposer:MFMessageComposeViewController = MFMessageComposeViewController()
    ////        present(smsComposer, animated: true)
    //    }
    
    @IBAction func shareRecipe(_ sender: Any) {
        for ingredient in ingredients {
            // don't force unwrap this
            ingredientsList = "\(ingredientsList), \(ingredient.original ?? " ")"
        }
        
        let recipeInfo: [String?] = [recipeName.text, " Summary: \(summary.text ?? "No Summary")", " Ingredients: \(ingredientsList)", " Instructions: \(instructions.text ?? "No Instructions")"]
        print(recipeInfo)
        
        let ac = UIActivityViewController(activityItems: recipeInfo as [Any], applicationActivities: [])
        present(ac, animated: true)
        
    }
    
    
    @IBAction func addFavorite(_ sender: Any) {
        getFavorites()
        
    }
    
    /*favoritesArray example:
     [["name": "Chicken Caesar Salad", "id": ######, "image":"imageURL"],["name": "Mac and Cheese", "id": ######, "image":"imageURL"]]
     */
    
    func getFavorites () {
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        db.collection("users").whereField("email", isEqualTo: email as Any).getDocuments() {
            (querySnapshot, err) in
            if let err = err
            { print("Error getting documents: \(err)") }
            else
            {
                guard let queryS = querySnapshot else {
                    return
                }
                let document = queryS.documents[0]
                let data = document.data()
                self.favoritesArray = data["favorites"] as? [[String:Any]] ?? []
            }
            
            
            let count = self.favoritesArray.count
            if count != 0{
                for index in (0...count-1).reversed() {
                    if (self.favoritesArray[index]["id"] as? Int ?? 0) == self.recipeID{
                        self.favoriteButton.setTitle("Add to Favorites", for: .normal)
                        self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                        self.favoritesArray.remove(at: index)
                        print("Successfully removed from favorites")
                    }
                }
            }
            if self.favoritesArray.count == count{
                let newFav: [String:Any] = ["name": self.recipeTitle as Any,"id": self.recipeID as Any, "image": self.imageURL as Any, "tag": self.recipeTags.text as Any]
                self.favoritesArray.append(newFav)
            }
            
            self.setFavorites()
        }
    }
    
    func setFavorites () {
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        db.collection("users").whereField("email", isEqualTo: email as Any).getDocuments() {
            (querySnapshot, err) in
            if let err = err
            { print("Error getting documents: \(err)") }
            else {
                guard let queryS = querySnapshot else {
                    return
                }
                let document = queryS.documents[0]
                document.reference.updateData(["favorites":self.favoritesArray]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.favoriteButton.setTitle("Added to Favorites", for: .normal)
                        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        print("Document successfully updated")
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func addComment(_ sender: Any) {
        let comment = commentText.text ?? ""
        
        if(comment != ""){
            let commentToPost = "\(name): \(comment)"
            
            
            db.collection("comments").whereField("id", isEqualTo: recipeID).getDocuments()
            {
                (querySnapshot, err) in
                
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    guard let queryS = querySnapshot else {
                        return
                    }
                    if(queryS.documents.count == 0)
                    {
                        //add document
                        self.addDocument(commentToPost: commentToPost)
                    }
                    else {
                        //append
                        guard let queryS = querySnapshot else {
                            return
                        }
                        let comments = queryS.documents[0].data()["comments"]
                        self.updateDocument(comments: comments as? [String] ?? [], commentToPost: commentToPost)
                    }
                }
            }
        }
        
        
    }
    
    
    func getInitComments(){
        db.collection("comments").whereField("id", isEqualTo: recipeID).getDocuments()
        {
            (querySnapshot, err) in
            
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                guard let queryS = querySnapshot else {
                    return
                }
                if(queryS.documents.count != 0)
                {
                    //add document
                    self.comments = queryS.documents[0].data()["comments"] as? [String] ?? []
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
        
        db.collection("comments").document(String(recipeID) ).setData(data as [String : Any]) { err in
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
        db.collection("comments").document(String(recipeID) ).setData(data as [String : Any]) { err in
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toWineVC") {
            
            guard let wineVC = segue.destination as? WineViewController else {
                return
            }
            
            
            wineVC.cuisine = "French"
            if(recipeTags.text != "")
            {
                wineVC.cuisine = recipeTags.text ?? "American"
            }
            if(recipeTags.text == "Mediterranean")
            {
                wineVC.cuisine = "Italian"
            }
            else if(recipeTags.text == "American" || recipeTags.text == "British")
            {
                wineVC.cuisine = "French"
            }
        }
        else if(segue.identifier == "toSimilarVC") {
            guard let similarVC = segue.destination as? SimilarViewController else {
                return
            }
            
            similarVC.recipeID = recipeID
            similarVC.parentVC = self
            
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
    
    
}
