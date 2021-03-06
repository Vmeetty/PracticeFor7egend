//
//  TableViewCell.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func detailsPressed(indexPath: IndexPath, recognizer: UITapGestureRecognizer)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var secondUserImageView: UIImageView!
    
    weak var delegate: TableViewCellDelegate?
    var indexPath: IndexPath!
    let feedVC = FeedViewController()
    var card: Card! {
        didSet {
            updateUI()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(detailsTaped(recognizer:)))
        pictureImageView.addGestureRecognizer(tapGR)
        pictureImageView.isUserInteractionEnabled = true
    }
    
    
    @objc func detailsTaped(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.pictureImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.2) {
                    self.pictureImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                } completion: { isFinished in
                    if isFinished {
                        UIView.animate(withDuration: 0.2) {
                            self.pictureImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
                    }
                }
            }
        }
        delegate?.detailsPressed(indexPath: indexPath, recognizer: recognizer)
    }
    
    
    private func updateUI() {
        
        configUI()
        pictureImageView.image = card.image
        titleLabel.text = card.title
        descriptionLabel.text = card.shortDescription
        topImageView.image = card.icon
        
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
        
    }
    
}
