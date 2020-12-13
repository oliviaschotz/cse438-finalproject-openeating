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

class RecipeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    let api_key = "7b2c5999d4f940a999efad739e883d3c"
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTags: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    
    var recipeID = 0
    var image = UIImage()
    var name = ""
    var ingredientsList: String = ""
    
    var favoritesArray: [Int] = []
    
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
    
    
    var theImageCache: [UIImage] = []
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
        
        recipeImage.image = image
        getRecipeInformation()
        
        getInitComments()
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.getSimilarRecipes()
//            DispatchQueue.main.async {
//                print("----RELOADING-----")
//                self.collectionView.reloadData()
//            }
//        }
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
            
            if self.favoritesArray.contains(self.recipeID){
                let index = self.favoritesArray.firstIndex(of: self.recipeID)
                self.favoritesArray.remove(at: index!)
            }
            else{
                self.favoritesArray.append(self.recipeID)
            }
            print(self.recipeID)
            self.setFavorites()
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
                print(querySnapshot!.documents)
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
        let urlPath = "https://api.spoonacular.com/recipes/"+String(recipeID)+"/similar?apiKey="+api_key
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let theData = try? JSONDecoder().decode([SimilarRecipe].self, from: data) else {
            print("SIMILAR error")
            return }
        
        similarResults = theData
        
        print("----DONE WITH RECIPES-----")
        
        getSimilarRecipeImages()
    }
    
    func getSimilarRecipeImages(){
        
        for recipe in similarResults {
            let urlPath = "https://api.spoonacular.com/recipes/"+String(recipe.id ?? 0)+"/information?apiKey="+api_key
            //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theRecipe = try? JSONDecoder().decode(Recipe.self, from: data) else {
                print("IMAGE error")
                return
            }
            
            let imagePath = theRecipe.image ?? ""
            guard let imageUrl = URL(string: imagePath) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            guard let image = UIImage(data: imageData) else { return }
            theImageCache.append(image)
        }
        
        print("----DONE WITH IMAGES-----")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("COLLECTION VIEW: \(similarResults.count)")
        return similarResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("-----SETTING UP CELLS------")
        print(similarResults[indexPath.row])
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as? SimilarRecipeCell ?? SimilarRecipeCell()
        
//        cell.similarImage.image = theImageCache[indexPath.row]
        cell.similarName.text = similarResults[indexPath.row].title
    
        return cell
        
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


