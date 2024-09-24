//
//  RankCell.swift
//  Life RPG
//
//  Created by Beau on 19/9/2567 BE.
//

import UIKit

class RankCell: UICollectionViewCell {
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var rankCharacterLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var requirementsLabel: UILabel!
    
    func configure(with rank: Rank) {
        
        rankCharacterLabel.text = rank.name
        
        if let imageUrlString = rank.image, let imageUrl = URL(string: imageUrlString) {
            loadImage(from: imageUrl)
            rankImage.layer.cornerRadius = 10
            rankImage.clipsToBounds = true
        } else {
            rankImage.image = nil
        }
        
        if let alphabetRankLabel = self.rankLabel {
            alphabetRankLabel.text = String(describing: rank.alphabetRank!)
        }
        
        requirementsLabel.text = "Requirements:".localized()
            
    }
    private func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.rankImage.image = image
                    }
                }
            }
            
        }
    }
    
}
