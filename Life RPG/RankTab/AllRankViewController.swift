//
//  AllRankViewController.swift
//  Life RPG
//
//  Created by Beau on 19/9/2567 BE.
//

import UIKit
import Alamofire

class AllRankViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Holds the fetched data
    var ranks: [Rank] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchData()
    }
    
    private func assignRanks() {
        // Rank list
        let ranksList: [String] = ["SSS+", "SSS", "SS", "A", "B", "C", "D", "E"]
        
        for (index, _) in ranks.enumerated() {
            if index < ranksList.count {
                ranks[index].alphabetRank = ranksList[index]
            } else {
                ranks[index].alphabetRank = "E"
            }
        }
    }
    
//    private func inspectJSONResponse() {
//        AF.request("https://hp-api.herokuapp.com/api/characters/staff").responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                print(value)
//                self.collectionView.reloadData()
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
    
    private func fetchData() {
        AF.request("https://hp-api.herokuapp.com/api/characters/staff").responseDecodable(of: [Rank].self) {response in
            switch response.result {
            case .success(let values):
                self.ranks = values.filter { $0.image != nil && !$0.image!.isEmpty }
                self.assignRanks()
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension AllRankViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ranks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCell", for: indexPath) as! RankCell
        
        let rank = ranks[indexPath.item]
        cell.configure(with: rank)

        return cell
        
    }
}
