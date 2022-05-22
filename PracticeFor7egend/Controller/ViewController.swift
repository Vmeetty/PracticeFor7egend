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
    
    var cardViewController: CardViewController!
    
    let cardHeight: CGFloat = 350
    
    var cardVisible = false
    var nextStep: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupCard() {
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.view.frame = CGRect(
            x: 0,
            y: self.view.frame.height,
            width: self.view.bounds.width,
            height: cardHeight)
        
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
    
}
