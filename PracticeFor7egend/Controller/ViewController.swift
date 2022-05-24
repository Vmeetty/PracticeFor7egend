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
            width: screenWidth - 50,
            height: screenHeight - 100
        )
        
        let timingLabel = banerViewController.timingLabel!
        banerViewController.view.addSubview(timingLabel)
        timingLabel.translatesAutoresizingMaskIntoConstraints = false
        timingLabel.alpha = 0

        let titleLabel = banerViewController.titleLabel!
        banerViewController.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.alpha = 0
        
        let xMarkImageView = banerViewController.xMarkImageView!
        banerViewController.view.addSubview(xMarkImageView)
        xMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        xMarkImageView.alpha = 0
        
        let iconImageView = banerViewController.iconImageView!
        banerViewController.view.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.alpha = 0
        
        let editLabel = banerViewController.editLabel!
        banerViewController.view.addSubview(editLabel)
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        editLabel.alpha = 0
        
        
        
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        banerViewController.backImageView.addGestureRecognizer(panGR)
        banerViewController.backImageView.isUserInteractionEnabled = true
        
        let xmarkTapGR = UITapGestureRecognizer(target: self, action: #selector(xmarkTaped(recognizer:)))
        banerViewController.xMarkImageView.addGestureRecognizer(xmarkTapGR)
        banerViewController.xMarkImageView.isUserInteractionEnabled = true
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
            animateTransitionIfNeeded(state: nextStep, duration: 0.2)
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
                    
                    self.updateLayout()
                    
                    self.banerViewController.timingLabel.alpha = 1
                    self.banerViewController.backImageView.alpha = 1
                    self.banerViewController.titleLabel.alpha = 1
                    self.banerViewController.iconImageView.alpha = 1
                    self.banerViewController.editLabel.alpha = 1
                    self.banerViewController.xMarkImageView.alpha = 1
                case .collapsed:
                    self.banerViewController.timingLabel.alpha = 0
                    self.banerViewController.backImageView.alpha = 0
                    self.banerViewController.titleLabel.alpha = 0
                    self.banerViewController.iconImageView.alpha = 0
                    self.banerViewController.editLabel.alpha = 0
                    self.banerViewController.xMarkImageView.alpha = 0
                }
                self.banerViewController.backImageView.layoutIfNeeded()
            }
            banerAnimator.startAnimation()
            runningAnimations.append(banerAnimator)
            
//            let buttonsAndLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state {
//                case .expanded:
//                    self.banerViewController.timingLabel.alpha = 1
//                case .collapsed:
//                    print("")
//                }
//            }
//            buttonsAndLabelAnimator.startAnimation()
//            runningAnimations.append(buttonsAndLabelAnimator)
        }
    }
    
    private func updateLayout() {
        NSLayoutConstraint.activate([
            self.banerViewController.backImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.banerViewController.backImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.banerViewController.backImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.banerViewController.backImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            self.banerViewController.timingLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -400),
            self.banerViewController.timingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            self.banerViewController.titleLabel.bottomAnchor.constraint(equalTo: self.banerViewController.timingLabel.bottomAnchor, constant: -40),
            self.banerViewController.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40),
            self.banerViewController.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            self.banerViewController.iconImageView.bottomAnchor.constraint(equalTo: self.banerViewController.titleLabel.bottomAnchor, constant: -80),
            self.banerViewController.iconImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40),
            self.banerViewController.iconImageView.widthAnchor.constraint(equalToConstant: 70),
            self.banerViewController.iconImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            self.banerViewController.editLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            self.banerViewController.editLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            self.banerViewController.xMarkImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            self.banerViewController.xMarkImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40),
            self.banerViewController.xMarkImageView.widthAnchor.constraint(equalToConstant: 40),
            self.banerViewController.xMarkImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
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
