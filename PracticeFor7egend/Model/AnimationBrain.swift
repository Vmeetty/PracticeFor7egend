//
//  Configure.swift
//  PracticeFor7egend
//
//  Created by user on 22.05.2022.
//

import Foundation
import UIKit

class AnimationBrain {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    static var shared = AnimationBrain()
    
    var rootViewController: FeedViewController!
    var descriptionViewController: DescriptionViewController!
    var banerViewController: BanerViewController!
    
    private let cardHeight: CGFloat = 300
    
    private var cardVisible = false
    private var nextStep: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
    
    
    func setupView(sender: UIViewController, withBanerVC banerVC: BanerViewController, andDescriptionVC descriptionVC: DescriptionViewController) {
        guard let rootVC = sender as? FeedViewController else { fatalError() }
        rootViewController = rootVC
        
        banerViewController = banerVC
        descriptionViewController = descriptionVC
        setupBanerView()
        setupDescriptionView()
    }
    
    private func setupDescriptionView() {
        descriptionViewController = DescriptionViewController(nibName: K.NibName.descNibName, bundle: nil)
        rootViewController.addChild(descriptionViewController)
        rootViewController.view.addSubview(descriptionViewController.view)
        descriptionViewController.view.frame = CGRect(
            x: 0,
            y: rootViewController.view.frame.height,
            width: rootViewController.view.bounds.width,
            height: cardHeight)
        
        descriptionViewController.view.clipsToBounds = true
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        descriptionViewController.handelArea.addGestureRecognizer(panGR)
        
        self.descriptionViewController.view.layer.cornerRadius = 30
    }
    
    private func setupBanerView() {
        rootViewController.addChild(banerViewController)
        rootViewController.view.addSubview(banerViewController.view)
        
        let backView = banerViewController.backImageView!
        banerViewController.view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.alpha = 0
        let screenWidth: CGFloat = rootViewController.view.frame.width
        let screenHeight: CGFloat = rootViewController.view.frame.height
        backView.frame = CGRect(
            x: rootViewController.view.center.x - ((screenWidth - 100) / 2),
            y: rootViewController.view.center.y - ((screenHeight - 80) / 2),
            width: screenWidth - 50,
            height: screenHeight - 100
        )
        
        configView(view: banerViewController.timingLabel!)
        configView(view: banerViewController.titleLabel!)
        configView(view: banerViewController.xMarkImageView!)
        configView(view: banerViewController.iconImageView!)
        configView(view: banerViewController.editLabel!)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        banerViewController.backImageView.addGestureRecognizer(panGR)
        banerViewController.backImageView.isUserInteractionEnabled = true
        
        let xmarkTapGR = UITapGestureRecognizer(target: self, action: #selector(xmarkTaped(recognizer:)))
        banerViewController.xMarkImageView.addGestureRecognizer(xmarkTapGR)
        banerViewController.xMarkImageView.isUserInteractionEnabled = true
    }
    
    private func configView(view: UIView) {
        let newView = view
        banerViewController.view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.alpha = 0
    }
    
    func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.animateTransitionIfNeeded(state: self.nextStep, duration: 0.3)
            }
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
    
    @objc func xmarkTaped(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextStep, duration: 0.5)
            continueInteractionTransition(state: nextStep)
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.descriptionViewController.view.frame.origin.y = self.rootViewController.view.frame.height - self.cardHeight
                case .collapsed:
                    self.descriptionViewController.view.frame.origin.y = self.rootViewController.view.frame.height
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
        }
    }
    
    private func updateLayout() {
        NSLayoutConstraint.activate([
            banerViewController.backImageView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
            banerViewController.backImageView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor),
            banerViewController.backImageView.rightAnchor.constraint(equalTo: rootViewController.view.rightAnchor),
            banerViewController.backImageView.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            banerViewController.timingLabel.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor, constant: -400),
            banerViewController.timingLabel.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            banerViewController.titleLabel.bottomAnchor.constraint(equalTo: banerViewController.timingLabel.bottomAnchor, constant: -40),
            banerViewController.titleLabel.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor, constant: 40),
            banerViewController.titleLabel.rightAnchor.constraint(equalTo: rootViewController.view.rightAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            banerViewController.iconImageView.bottomAnchor.constraint(equalTo: banerViewController.titleLabel.bottomAnchor, constant: -80),
            banerViewController.iconImageView.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor, constant: 40),
            banerViewController.iconImageView.widthAnchor.constraint(equalToConstant: 70),
            banerViewController.iconImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            banerViewController.editLabel.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            banerViewController.editLabel.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            banerViewController.xMarkImageView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            banerViewController.xMarkImageView.rightAnchor.constraint(equalTo: rootViewController.view.rightAnchor, constant: -40),
            banerViewController.xMarkImageView.widthAnchor.constraint(equalToConstant: 40),
            banerViewController.xMarkImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateIntarectiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractionTransition(state: CardState) {
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
    
    func populateDetails(ofCard card: Card) {
        banerViewController.titleLabel.text = card.title
        banerViewController.timingLabel.text = card.timing
        banerViewController.iconImageView.image = card.icon
        banerViewController.backImageView.image = card.image
        descriptionViewController.cityLabel.text = card.city
        descriptionViewController.fullDescription.text = card.fullDescription
        descriptionViewController.shortDescription.text = card.shortDescription
    }
    
}
