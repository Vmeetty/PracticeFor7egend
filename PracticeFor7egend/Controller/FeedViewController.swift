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
    
    @objc func detailsTaped() {
        print("Open Detail View")
    }


}

// CASH CELLS <<<<<<<<<<<<-------------------<<<<<<<<<-----------------



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
        cell.card = cards[indexPath.row]
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(detailsTaped))
        cell.pictureImageView.addGestureRecognizer(tapGR)
        cell.pictureImageView.isUserInteractionEnabled = true
        
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



