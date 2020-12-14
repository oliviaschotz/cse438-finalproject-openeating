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
    
    //api website: https://spoonacular.com/food-api
    //api documentation: https://spoonacular.com/food-api/docs
    //example: https://api.spoonacular.com/recipes/716429/information?apiKey=61de2798dcdc47c88f2279d7c23dad64&includeNutrition=true
    
    var spinner = UIActivityIndicatorView(style: .large)
    var noResults: UILabel!
    
    var first_load = true
    
    let api_key = "310d7b1a09564709a55a3672d7565eca"
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
    
    var userPreferences: [String:Any] = [:]
    
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
        
        
        let noResultsFrame = CGRect(x: view.frame.midX - (83/2), y: view.frame.midY - (21/2), width: 83, height: 21)
        noResults = UILabel(frame: noResultsFrame)
        noResults.text = "No Results"
        noResults.isHidden = true
        view.addSubview(noResults)

        //potential for nutrition info *
        //potential to sort recipes in diff ways

        //example https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query=pasta&diet=vegetarian&intolerance=peanut,soy&addRecipeInformation=true
        //get recipes with intolerances, diet and search query
        
        getUserPreferences()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        getUserPreferences()
    }
    
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func getUserPreferences(){
        
        let info = UserDefaults.standard.object(forKey: "userInfo") as? Dictionary<String, String> ?? [:]
        let email = info["email"]
        
        db.collection("users").whereField("email", isEqualTo: email as Any).getDocuments()
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
                    let document = queryS.documents[0]
                    self.userPreferences = document.data() as [String:Any]
                    self.formatOptions()
                    
                    
                }
        }
    }
    
    func formatOptions(){
        diet = ""
        intolerances = ""
        
        for (k,v) in userPreferences {
            if(v) as? Bool ?? false{
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
        
        if(first_load){
            cuisineData(cuisine: "american")
            first_load = false
        }
        
    }

    func fetchDataForTableView()
        {
            
//            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query="+query+"&diet="+diet+"&intolerance="+intolerances
            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey="+api_key+"&query="+searchVal+"&diet="+diet+"&intolerance="+intolerances
            //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theData = try? JSONDecoder().decode(APIResults.self, from: data) else {
                print("error")
                return }
            recipeResults = theData.results
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
        searchVal = searchVal.replacingOccurrences(of: " ", with: "+")
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
        if(recipeResults.count == 0){
            noResults.isHidden = false;
        }
        else {
            noResults.isHidden = true;
        }
        return recipeResults.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCell else {
            return RecipeCell()
        }
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

            guard let tblView = self.tableView else {
                return
            }
            guard let indexPaths = tblView.indexPathsForSelectedRows else {
                return
            }
            let indexPath = indexPaths[0] as NSIndexPath
            let selectedRecipe = recipeResults[indexPath.row]
            
            guard let recipeVC = segue.destination as? RecipeDetailsViewController else {
                return
            }
            
            recipeVC.recipeID = selectedRecipe.id ?? 0
            recipeVC.image = theImageCache[indexPath.row]
            recipeVC.imageURL = selectedRecipe.image ?? ""
            recipeVC.name = userPreferences["name"] as? String ?? ""
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
            let urlPath = "https://api.spoonacular.com/recipes/complexSearch?apiKey="+self.api_key+"&cuisine="+cuisine+"&diet="+self.diet+"&intolerance="+self.intolerances
                        //Lainie- may need to add a line that allows for having spaces in the search query (I have this in my movie lab)
            guard let url = URL(string: urlPath) else { return  }
            print(url)
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
