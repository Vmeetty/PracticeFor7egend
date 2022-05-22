//
//  DetailsView.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import UIKit

protocol DetailsViewDelegate: AnyObject {
    func didCloseDetails(_ view: DetailsView)
}

class DetailsView: UIView {
    
    weak var delegate: DetailsViewDelegate?

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var boldDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    
    
    
    
    @objc func closeDetails() {
        removeFromSuperview()
        delegate?.didCloseDetails(self)
    }
    

}
