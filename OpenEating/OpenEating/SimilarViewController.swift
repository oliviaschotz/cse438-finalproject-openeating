//
//  SimilarViewController.swift
//  OpenEating
//
//  Created by Olivia Schotz on 12/13/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class SimilarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let api_key = "c0dec883d5804d89bc70440f44cdd08c"
    
    var recipeID = 0
    var spinner = UIActivityIndicatorView(style: .large)
    
    var parentVC = RecipeDetailsViewController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var theImageCache: [UIImage] = []
    var similarResults: [SimilarRecipe] = []
    
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let theSpinnerView = CGRect(x: view.frame.midX-15, y: view.frame.midY-15, width: 30, height: 30)
        spinner = UIActivityIndicatorView(frame: theSpinnerView)
        view.addSubview(spinner)
        
        getSimilarRecipes()
    }
    
    //    DispatchQueue.global(qos: .userInitiated).async {
    //        self.getSimilarRecipes()
    //        DispatchQueue.main.async {
    //            print("----RELOADING-----")
    //            self.collectionView.reloadData()
    //        }
    //    }
    
    func getSimilarRecipes(){
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let urlPath = "https://api.spoonacular.com/recipes/\(String(self.recipeID))/similar?apiKey=\(self.api_key)"
            guard let url = URL(string: urlPath) else { return  }
            guard let data =  try?  Data(contentsOf: url) else { return }
            guard let theData = try? JSONDecoder().decode([SimilarRecipe].self, from: data) else {
                print("SIMILAR error")
                return }
            
            self.similarResults = theData
            
            self.getSimilarRecipeImages()
            
            DispatchQueue.main.async {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
            
        }
        
        
    }
    
    func getSimilarRecipeImages(){
        
        for recipe in similarResults {
            let urlPath = "https://api.spoonacular.com/recipes/"+String(recipe.id ?? 0)+"/information?apiKey="+self.api_key
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
            self.theImageCache.append(image)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as? SimilarRecipeCell ?? SimilarRecipeCell()
        
        cell.similarImage.image = theImageCache[indexPath.row]
        cell.similarName.text = similarResults[indexPath.row].title
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentVC.recipeID = similarResults[indexPath.row].id ?? 0
        parentVC.image = theImageCache[indexPath.row]
        self.navigationController?.popToViewController(parentVC, animated: true)
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
