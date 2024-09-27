//
//  AllRankViewController.swift
//  Life RPG
//
//  Created by Beau on 19/9/2567 BE.
//

import UIKit
import Alamofire
import AVFoundation


class AllRankViewController: UIViewController {
    
    @IBOutlet weak var rankTitleLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Holds the fetched data
    var ranks: [Rank] = []
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchData()
        updateLocalizationUI()
        
        playBackgroundMusic()

    }
    
    private func playBackgroundMusic() {
        guard let path = Bundle.main.path(forResource: "harrypotterTheme", ofType: "mp3") else {
            print("Music file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop the music indefinitely
            audioPlayer?.play()
        } catch {
            print("Error playing background music: \(error)")
        }
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
    
    @objc func updateLocalizationUI() {
        rankTitleLabel.text = "All Ranks - Hogwarts".localized()
    }
}
