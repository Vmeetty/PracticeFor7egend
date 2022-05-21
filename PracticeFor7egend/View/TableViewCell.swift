//
//  TableViewCell.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var secondUserImageView: UIImageView!
    
    var card: Card! {
        didSet {
            updateUI()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @objc func detailsTaped() {
        print("Open Detail View")
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    private func updateUI() {
        
        configUI()
        pictureImageView.image = card.image
        titleLabel.text = card.title
        descriptionLabel.text = card.description
        topImageView.image = card.topImage
        
        if let userImage1 = card.user1 {
            firstUserImageView.image = userImage1
        } else {
            firstUserImageView.isHidden = true
        }
        if let userImage2 = card.user2 {
            secondUserImageView.image = userImage2
        } else {
            secondUserImageView.isHidden = true
        }
        
    }
    
    
    private func configUI() {
        pictureImageView.layer.cornerRadius = 20
        firstUserImageView.layer.cornerRadius = firstUserImageView.frame.size.height / 2
        secondUserImageView.layer.cornerRadius = secondUserImageView.frame.size.height / 2
        pictureImageView.contentMode = .scaleAspectFill
        firstUserImageView.contentMode = .scaleAspectFill
        secondUserImageView.contentMode = .scaleAspectFill
        pictureImageView.clipsToBounds = true
        firstUserImageView.clipsToBounds = true
        secondUserImageView.clipsToBounds = true
        firstUserImageView.layer.borderWidth = 1
        firstUserImageView.layer.borderColor = UIColor.white.cgColor
        secondUserImageView.layer.borderWidth = 1
        secondUserImageView.layer.borderColor = UIColor.white.cgColor
        
        let tapGR = UIGestureRecognizer(target: self, action: #selector(detailsTaped))
        pictureImageView.addGestureRecognizer(tapGR)
        pictureImageView.isUserInteractionEnabled = true
    }
    
}
