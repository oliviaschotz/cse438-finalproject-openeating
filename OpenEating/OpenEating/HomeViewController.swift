//
//  HomeViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var documentID = ""
    
    //api website: https://spoonacular.com/food-api
    //api documentation: https://spoonacular.com/food-api/docs
    //example: https://api.spoonacular.com/recipes/716429/information?apiKey=61de2798dcdc47c88f2279d7c23dad64&includeNutrition=true
    
    var spinner = UIActivityIndicatorView(style: .large)
    let api_key = "61de2798dcdc47c88f2279d7c23dad64"
//    let query = "pasta"
    var diet = ""
    var intolerances = ""
    let addRecipeInformation = true
    
    var theImageCache: [UIImage] = []
    var searchVal = ""
    var recipeResults: [Recipe] = []
    
    struct APIResults:Decodable {
        let offset: Int?
        let number: Int?
        let results: [Recipe]
        let totalResults: Int?
    }
       
    struct Recipe: Decodable {
        let id: Int?
        let calories: String?
        let carbs: String?
        let fat: String?
        let image: String?
        let imageType: String?
        let protein: String?
        let title: String?
    }
    
    var userPreferences: [String:Bool] = [:]
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let theSpinnerView = CGRect(x: view.frame.midX-15, y: view.frame.midY-15, width: 30, height: 30)
        spinner = UIActivityIndicatorView(frame: theSpinnerView)
        view.addSubview(spinner)

        //potential for nutrition info *
        //potential to sort recipes in diff ways

        //example https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query=pasta&diet=vegetarian&intolerance=peanut,soy&addRecipeInformation=true
        //get recipes with intolerances, diet and search query
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
            print("user signed in")
        } else {
          // No user is signed in.
            print("no user signed in")
            let welcomeVC = self.storyboard?.instantiateViewController(identifier: "WelcomeVC") as! ViewController
            self.present(welcomeVC, animated:true, completion: nil)
        }
        
        getUserPreferences()
    }
    

    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func getUserPreferences(){
        
        print("----DOCUMENT ID----: \(documentID)")
        
        let docRef = db.collection("users").document("userPreferences")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userPreferences = document.data() as? Dictionary<String, Bool> ?? [:]
                print("Document data: \(self.userPreferences)")
                self.formatOptions()
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
    func formatOptions(){
        diet = ""
        intolerances = ""
        
        for (k,v) in userPreferences {
            if(v){
                if(k.firstIndex(of: "F") != nil){
                    intolerances += k[..<(k.firstIndex(of: "F") ?? k.endIndex)]+","
                }
                else {
                    diet += k+","
                }
            }
        }
        
        if(diet.count > 0){
            let idx = diet.lastIndex(of: ",") ?? diet.endIndex
            diet = String(diet[..<idx])
        }
        
        if(intolerances.count > 0){
            let idx = intolerances.lastIndex(of: ",") ?? intolerances.endIndex
            intolerances = String(intolerances[..<idx])
        }
        
    }

    func fetchDataForTableView()
        {
            
//            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query="+query+"&diet="+diet+"&intolerance="+intolerances
            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query="+searchVal+"&diet="+diet+"&intolerance="+intolerances
            //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theData = try? JSONDecoder().decode(APIResults.self, from: data) else {
                print("error")
                return }
            recipeResults = theData.results
            print(url)
        }

    func cacheInfo()
    {
        theImageCache.removeAll()
        for recipe in recipeResults
        {
            let imagePath = recipe.image ?? ""
            if(imagePath.count != 0)
            {
                guard let url = URL(string: imagePath) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                theImageCache.append(image)
            }
                //if it doesn't contain an image -> use a placeholder
//            else
//            {
//                guard let image: UIImage = UIImage(named: "noImage") else { return }
//                theImageCache.append(image)
//            }
            
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchVal = searchBar.text ?? ""
        spinner.isHidden = false
        spinner.startAnimating()
        spinner.backgroundColor = UIColor.white
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForTableView()
            self.cacheInfo()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeResults.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
//            UITableViewCell(style: .subtitle, reuseIdentifier: "recipeCell") as! RecipeCell
        cell.recipeName.text = recipeResults[indexPath.row].title
        cell.recipeImage.image = theImageCache[indexPath.row]
        return cell
    }
    
    private func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(278)
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
            let selectedRecipe = recipeResults[indexPath.row]
            
            guard let recipeVC = segue.destination as? RecipeDetailsViewController else {
                return
            }
            
            recipeVC.recipeID = selectedRecipe.id ?? 0
            recipeVC.image = theImageCache[indexPath.row]
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
    
    @IBAction func americanFood(_ sender: Any) {
        cuisineData(cuisine: "american")
    }
    
    @IBAction func chineseFood(_ sender: Any) {
        cuisineData(cuisine: "chinese")
    }
    
    @IBAction func italianFood(_ sender: Any) {
        cuisineData(cuisine: "italian")
    }
    
    @IBAction func greekFood(_ sender: Any) {
        cuisineData(cuisine: "greek")
    }
    
    @IBAction func japaneseFood(_ sender: Any) {
        cuisineData(cuisine: "japanese")
    }
    
    func cuisineData(cuisine: String)
    {
        spinner.isHidden = false
        spinner.startAnimating()
        spinner.backgroundColor = UIColor.white
        DispatchQueue.global(qos: .userInitiated).async {
            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&cuisine="+cuisine+"&diet="+self.diet+"&intolerance="+self.intolerances
                        //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theData = try? JSONDecoder().decode(APIResults.self, from: data) else {
                print("error")
                return }
            self.recipeResults = theData.results
            self.cacheInfo()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
}
