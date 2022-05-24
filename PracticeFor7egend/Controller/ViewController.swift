//
//  ViewController.swift
//  PracticeFor7egend
//
//  Created by user on 23.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var descriptionViewController: DescriptionViewController!
    var banerViewController: BanerViewController!
    
    let cardHeight: CGFloat = 300
    
    var cardVisible = false
    var nextStep: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBanerView() {
        banerViewController = BanerViewController(nibName: K.NibName.banerNibName, bundle: nil)
        
        self.addChild(banerViewController)
        self.view.addSubview(banerViewController.view)
        
        let backView = banerViewController.backImageView!
        banerViewController.view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.alpha = 0
        let screenWidth: CGFloat = view.frame.width
        let screenHeight: CGFloat = view.frame.height
        backView.frame = CGRect(
            x: view.center.x - ((screenWidth - 100) / 2),
            y: view.center.y - ((screenHeight - 80) / 2),
            width: screenWidth - 100,
            height: screenHeight - 80)
        
        
        let timingView = self.banerViewController.timingLabel!
//        timingView.widthAnchor.constraint(equalToConstant: screenWidth - 80).isActive = true
//        self.banerViewController.view.addSubview(timingView)
        
//        timingView.translatesAutoresizingMaskIntoConstraints = false
//        timingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        timingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 40).isActive = true
//        timingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
//        timingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
        
//        banerImageView.addSubview(banerViewController.titleLabel)
//        banerViewController.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        banerImageView.addSubview(banerViewController.iconImageView)
//        banerImageView.addSubview(banerViewController.xmarkImageView)
//        banerImageView.addSubview(banerViewController.editLabel)
//        banerImageView.addSubview(banerViewController.profileImageView)
        
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        banerViewController.backImageView.addGestureRecognizer(panGR)
        banerViewController.backImageView.isUserInteractionEnabled = true
        
        let xmarkTapGR = UITapGestureRecognizer(target: self, action: #selector(xmarkTaped(recognizer:)))
        banerViewController.xmarkImageView.addGestureRecognizer(xmarkTapGR)
        banerViewController.xmarkImageView.isUserInteractionEnabled = true
    }
    
    
    
    
    func setupDescriptionView() {
        descriptionViewController = DescriptionViewController(nibName: K.NibName.descNibName, bundle: nil)
        self.addChild(descriptionViewController)
        self.view.addSubview(descriptionViewController.view)
        descriptionViewController.view.frame = CGRect(
            x: 0,
            y: self.view.frame.height,
            width: self.view.bounds.width,
            height: cardHeight)
        
        descriptionViewController.view.clipsToBounds = true
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        descriptionViewController.handelArea.addGestureRecognizer(panGR)
        
        self.descriptionViewController.view.layer.cornerRadius = 30
    }
    
    private func populateDetails(ofCard card: Card) {
        banerViewController.titleLabel.text = card.title
        banerViewController.timingLabel.text = card.timing
        banerViewController.iconImageView.image = card.icon
        banerViewController.backImageView.image = card.image
        descriptionViewController.cityLabel.text = card.city
        descriptionViewController.fullDescription.text = card.fullDescription
        descriptionViewController.shortDescription.text = card.shortDescription
    }
    
    @objc func xmarkTaped(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextStep, duration: 0.5)
        default:
            break
        }
    }
    
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextStep, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: banerViewController.backImageView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateIntarectiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractionTransition(state: nextStep)
        default:
            break
        }
    }
    
    func handleCardTap(recognizer: UITapGestureRecognizer, card: Card) {
        setupBanerView()
        setupDescriptionView()
        populateDetails(ofCard: card)
        
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextStep, duration: 2)
        default:
            break
        }
    }
    
    
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.descriptionViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.descriptionViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let banerAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    NSLayoutConstraint.activate([
                        self.banerViewController.backImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
                        self.banerViewController.backImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        self.banerViewController.backImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                        self.banerViewController.backImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
                    ])
                    self.banerViewController.backImageView.alpha = 1
                case .collapsed:
                    self.banerViewController.backImageView.alpha = 0
                }
                self.view.layoutIfNeeded()
            }
            banerAnimator.startAnimation()
            runningAnimations.append(banerAnimator)
            
//            let topButtonsAnimator = UIViewPropertyAnimator(duration: duration - 0.1, curve: .linear) {
//                switch state {
//                case .expanded:
//                    print("")
//                case .collapsed:
//                    print("")
//                }
//            }
//            topButtonsAnimator.startAnimation()
//            runningAnimations.append(topButtonsAnimator)
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
    
    func continueInteractionTransition(state: CardState) {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        switch state {
        case .expanded:
            print("expanded")
        case .collapsed:
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.banerViewController.view.removeFromSuperview()
            }
        }
        
    }
    
}
