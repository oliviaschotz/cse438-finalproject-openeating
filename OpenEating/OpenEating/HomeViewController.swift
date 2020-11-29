//
//  HomeViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 11/25/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //api website: https://spoonacular.com/food-api
    //api documentation: https://spoonacular.com/food-api/docs
    //example: https://api.spoonacular.com/recipes/716429/information?apiKey=61de2798dcdc47c88f2279d7c23dad64&includeNutrition=true
    
    var spinner = UIActivityIndicatorView(style: .large)
    let api_key = "61de2798dcdc47c88f2279d7c23dad64"
//    let query = "pasta"
    let diet = "vegetarian"
    let intolerances = "peanut,soy"
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
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        let theSpinnerView = CGRect(x: view.frame.midX-15, y: view.frame.midY-15, width: 30, height: 30)
        spinner = UIActivityIndicatorView(frame: theSpinnerView)
        view.addSubview(spinner)

        //potential for nutrition info *
        //potential to sort recipes in diff ways

        //example https://api.spoonacular.com/recipes/complexSearch?apiKey=61de2798dcdc47c88f2279d7c23dad64&query=pasta&diet=vegetarian&intolerance=peanut,soy&addRecipeInformation=true
        //get recipes with intolerances, diet and search query
    }
    

    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = recipeResults[indexPath.row].title
        cell.imageView?.image = theImageCache[indexPath.row]
        return cell
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
