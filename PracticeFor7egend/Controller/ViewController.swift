//
//  ViewController.swift
//  PracticeFor7egend
//
//  Created by user on 23.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let animationAndConfig = AnimationBrain.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func handleCardTap(recognizer: UITapGestureRecognizer, card: Card) {
        let banerVC = BanerViewController(nibName: K.NibName.banerNibName, bundle: nil)
        let descriptionVC = DescriptionViewController(nibName: K.NibName.descNibName, bundle: nil)
        animationAndConfig.setupView(sender: self, withBanerVC: banerVC, andDescriptionVC: descriptionVC)

        animationAndConfig.populateDetails(ofCard: card)
        animationAndConfig.handleCardTap(recognizer: recognizer)
        
    }
    
   
    
}
