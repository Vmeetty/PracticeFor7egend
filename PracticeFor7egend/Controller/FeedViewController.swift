//
//  FeedViewController.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import UIKit

class FeedViewController: ViewController {
    
    var cards = Manager.shared.fetchCards()

    @IBOutlet weak var tableView: UITableView!
    
    
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
//        cell.delegate = self
        cell.card = cards[indexPath.row]
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        cell.pictureImageView.addGestureRecognizer(tapGR)
        cell.pictureImageView.isUserInteractionEnabled = true
                
        return cell
    }
}


extension FeedViewController: DetailsViewDelegate {
    func didCloseDetails(_ view: DetailsView) {
        //...
    }
}

//extension FeedViewController: TableViewCellDelegate {
//    func detailsPressed(indexPath: IndexPath) {
//        guard let card = cards?[indexPath.row] else {
//            print("No data for card")
//            return
//        }
//        guard let detailView = Configure.shared.configDetailsWith(card: card, and: self) else {
//            print("Faild DetailsView config")
//            return
//        }
//
//        detailView.translatesAutoresizingMaskIntoConstraints = false
//        detailView.frame = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
//
//        detailView.delegate = self
//        view.addSubview(detailView)
//
//        UIView.animate(withDuration: 0.5) {
//            NSLayoutConstraint.activate([
//                detailView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//                detailView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//                detailView.topAnchor.constraint(equalTo: self.view.topAnchor),
//                detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//            ])
//            self.view.layoutIfNeeded()
//        }
//    }
//}
