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
    
    var indexPathSelected: IndexPath?
    
    let animationAndConfig = AnimationBrain.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.panGestureRecognizer.addTarget(self, action: #selector(didPan(_:)))
        
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let service = Service.shared
        service.animateCellsFor(tableView: tableView, by: gesture)
    }
}



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
        cell.delegate = self
        cell.indexPath = indexPath
        cell.card = cards[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}


extension FeedViewController: TableViewCellDelegate {
    func detailsPressed(indexPath: IndexPath, recognizer: UITapGestureRecognizer) {
        guard let card = cards?[indexPath.row] else {
            print("No data for card")
            return
        }
        indexPathSelected = indexPath
        
        let banerVC = BanerViewController(nibName: K.NibName.banerNibName, bundle: nil)
        let descriptionVC = DescriptionViewController(nibName: K.NibName.descNibName, bundle: nil)
        animationAndConfig.setupView(sender: self, withBanerVC: banerVC, andDescriptionVC: descriptionVC)

        animationAndConfig.populateDetails(ofCard: card)
        animationAndConfig.handleCardTap(recognizer: recognizer)
    }
}

