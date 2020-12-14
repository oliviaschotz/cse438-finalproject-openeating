//
//  WineViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 12/13/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class WineViewController: UIViewController{
    
    struct WinePairings: Decodable {
        var pairedWines: [String]?
        var pairingText: String?
        var productMatches: [Wine]
    }
    
    struct Wine: Decodable {
        var id: Int?
        var title: String?
        var averageRating: Double?
        var description: String?
        var imageUrl: String?
        var link: String?
        var price: String?
        var ratingCount: Double?
        var score: Double?
        
    }
    

    @IBOutlet weak var wineImage: UIImageView!
    @IBOutlet weak var wineName: UILabel!
    @IBOutlet weak var wineDescription: UILabel!
    @IBOutlet weak var descriptio: UILabel!
    var cuisine: String = ""
    let api_key = "725e6de7f0424a3aaf43d93459d1373e"
    var wines: [Wine] = []

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cuisine)
        
       let urlPath = "https://api.spoonacular.com/food/wine/pairing?food=\(cuisine)&apiKey="+api_key
        print(urlPath)
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let wineResults = try? JSONDecoder().decode(WinePairings.self, from: data) else {
            print("error")
            return
        }
        wines = wineResults.productMatches
        if(wines.count > 0)
        {
            let wine: Wine = wines[0]
            wineName.text = wine.title ?? "Wine #1"
            wineDescription.text = wine.description ?? "No description available"
            guard let url = URL(string: wine.imageUrl ?? "") else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            wineImage.image = UIImage(data: data) 
            print(wines)
        }
        else
        {
            descriptio.isHidden = true
            wineName.text = "No wine pairing(s) available"
            wineDescription.isHidden = true
            wineImage.isHidden = true
        }
        
        // Do any additional setup after loading the view.
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
