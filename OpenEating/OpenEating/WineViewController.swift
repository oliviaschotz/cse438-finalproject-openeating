//
//  WineViewController.swift
//  OpenEating
//
//  Created by Danielle Sharabi on 12/13/20.
//  Copyright © 2020 Olivia Schotz. All rights reserved.
//

import UIKit

class WineViewController: UIViewController{
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return wines.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "wineCell", for: indexPath) as? WineCell ?? WineCell()
//        //cell.recipeTags.text = ""
//        cell.recipeName.text = wines[indexPath.row].title
//        return cell
//    }
    

    @IBOutlet weak var tableView: UITableView!
    var cuisine: String = ""
    let api_key = "7b2c5999d4f940a999efad739e883d3c"
    var wines: [Wine] = []

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cuisine)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
       let urlPath = "https://api.spoonacular.com/food/wine/pairing?food=\(cuisine)&apiKey="+api_key
        print(urlPath)
        guard let url = URL(string: urlPath) else { return  }
        guard let data =  try?  Data(contentsOf: url) else { return }
        guard let wineResults = try? JSONDecoder().decode(WinePairings.self, from: data) else {
            print("error")
            return
        }
        wines = wineResults.productMatches
        print(wines)
        
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
