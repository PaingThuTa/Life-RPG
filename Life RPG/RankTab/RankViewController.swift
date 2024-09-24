//
//  RankViewController.swift
//  Life RPG
//
//  Created by Beau on 18/9/2567 BE.
//

import UIKit

class RankViewController: UIViewController {
    
    @IBOutlet weak var currentRankLabel: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    @IBOutlet weak var EXPToLevelUpLabel: UILabel!
    @IBOutlet weak var TotalExpLabel: UILabel!
    
    @IBOutlet weak var yourRankLabel: UILabel!
    @IBOutlet weak var headLevelLabel: UILabel!
    @IBOutlet weak var headEXPToLevelUpLabel: UILabel!
    @IBOutlet weak var headTotalEXPLabel: UILabel!
    
    @IBOutlet weak var allRankButton: UIButton!
    
    @IBOutlet weak var castingSpellImageView: UIImageView!
    @IBOutlet weak var ghoulImageView: UIImageView!
    
    var castingSpellImages: [UIImage] = []
    var ghoulImages: [UIImage] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocalizationUI()
        
        castingSpellImages = createImageArray(total: 14, imagePrefix: "castingSpell")
        ghoulImages = createImageArray(total: 9, imagePrefix: "Ghoul")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateHarry(imageView: castingSpellImageView, images: castingSpellImages)
        animateGhoul(imageView: ghoulImageView, images: ghoulImages)
        
    }
    
    @IBAction func AllRankButtonTapped(_ sender: UIButton) {
        
    }

    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }
    
    func animateHarry(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 2.0
        imageView.animationRepeatCount = 3
        imageView.startAnimating()
    }
    
    func animateGhoul(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 3.0
        imageView.animationRepeatCount = 2
        imageView.startAnimating()
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        yourRankLabel.text = "Your Rank".localized()
        headLevelLabel.text = "Level".localized()
        headEXPToLevelUpLabel.text = "EXP To Level Up".localized()
        headTotalEXPLabel.text = "Total EXP".localized()

//        let smallerFont = UIFont.systemFont(ofSize: 14) // Choose your desired size here
        allRankButton.setTitle("All Ranks".localized(), for: .normal)
//        allRankButton.titleLabel?.font = smallerFont
        
    }
}
