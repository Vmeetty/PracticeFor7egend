//
//  FeedViewController.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    var cards = Manager.shared.fetchCards()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }


}

// CASH CELLS <<<<<<<<<<<<-------------------<<<<<<<<<-----------------
// SHADOWS <<<<<<<<<<<<<-------------------<<<<<<<<<<<<<<<------------------



//MARK: - DataSource section

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.IDs.cellID, for: indexPath) as! TableViewCell
        
        guard let cards = cards else {
            var content = cell.defaultContentConfiguration()
            content.text = "No items yet"
            cell.contentConfiguration = content
            return cell
        }
        cell.indexPath = indexPath
        cell.delegate = self
        cell.card = cards[indexPath.row]
        
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(detailsTaped))
//        cell.pictureImageView.addGestureRecognizer(tapGR)
//        cell.pictureImageView.isUserInteractionEnabled = true
        
        return cell
    }
}

//MARK: - Delegate section

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.1 * Double(indexPath.row)) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
}


extension FeedViewController: TableViewCellDelegate {
    func detailsPressed(indexPath: IndexPath) {
        guard let detailView = Bundle.main.loadNibNamed("DetailsView", owner: nil, options: nil)?.first as? DetailsView else { return }
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.frame = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        detailView.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: detailView, action: #selector(detailView.closeDetails))
        detailView.backgroundImageView.addGestureRecognizer(tapGR)
        detailView.backgroundImageView.isUserInteractionEnabled = true
        
        if let cards = cards {
            
            detailView.titleLabel.text = cards[indexPath.row].title
            view.addSubview(detailView)
        }
        
        UIView.animate(withDuration: 0.5) {
            NSLayoutConstraint.activate([
                detailView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                detailView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                detailView.topAnchor.constraint(equalTo: self.view.topAnchor),
                detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            self.view.layoutIfNeeded()
        }
    }
}


extension FeedViewController: DetailsViewDelegate {
    func didCloseDetails(_ view: DetailsView) {
        print("Closed!")
    }
}

