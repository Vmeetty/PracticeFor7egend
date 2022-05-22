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
    
   
    //MARK: - START
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController: CardViewController!
    
    let cardHeight: CGFloat = 350
    let cardHandleAreaHeight: CGFloat = 65
    
    var cardVisible = false
    var nextStep: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
  
    //MARK: - END
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.panGestureRecognizer.addTarget(self, action: #selector(didPan(_:)))

    }

    
    //MARK: - START
    
    
    func setupCard() {
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        cardViewController.handelArea.addGestureRecognizer(panGR)
        
        self.cardViewController.view.layer.cornerRadius = 30
    }
    
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextStep, duration: 0.9)
        case .changed:
            updateIntarectiveTransition(fractionCompleted: 0)
        case .ended:
            continueInteractionTransition()
        default:
            break
        }
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        setupCard()
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextStep, duration: 0.9)
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateIntarectiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractionTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
        
    //MARK: - END
    
    
    
    

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
        cell.delegate = self
        cell.card = cards[indexPath.row]
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        cell.pictureImageView.addGestureRecognizer(tapGR)
        cell.pictureImageView.isUserInteractionEnabled = true
                
        return cell
    }
}



extension FeedViewController: TableViewCellDelegate {
    func detailsPressed(indexPath: IndexPath) {
        guard let card = cards?[indexPath.row] else {
            print("No data for card")
            return
        }
        guard let detailView = Configure.shared.configDetailsWith(card: card, and: self) else {
            print("Faild DetailsView config")
            return
        }
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.frame = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        
        detailView.delegate = self
        view.addSubview(detailView)
        
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
        //...
    }
}

