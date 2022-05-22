//
//  Configure.swift
//  PracticeFor7egend
//
//  Created by user on 22.05.2022.
//

import Foundation
import UIKit

struct Configure {
    
    static var shared = Configure()
    
    func configDetailsWith(card: Card, and sender: UIViewController) -> DetailsView? {
        guard let detailView = Bundle.main.loadNibNamed("DetailsView", owner: nil, options: nil)?.first as? DetailsView else { return nil }
//        detailView.translatesAutoresizingMaskIntoConstraints = false
//        detailView.frame = CGRect(x: sender.view.center.x, y: sender.view.center.y, width: 0, height: 0)
        
        detailView.backgroundImageView.image = card.image
        detailView.titleLabel.text = card.title
        detailView.boldDescriptionLabel.text = card.shortDescription
        detailView.iconImageView.image = card.icon
        detailView.descriptionLabel.text = card.fullDescription
        detailView.cityLabel.text = card.city
        detailView.timingLabel.text = card.timing
        
        detailView.bottomContainerView.layer.cornerRadius = 30
        
        let tapGR = UITapGestureRecognizer(target: detailView, action: #selector(detailView.closeDetails))
        detailView.backgroundImageView.addGestureRecognizer(tapGR)
        detailView.backgroundImageView.isUserInteractionEnabled = true
        
        return detailView
    }
    
//    private func fetchDetails() -> Details {
//
//    }
    
}
