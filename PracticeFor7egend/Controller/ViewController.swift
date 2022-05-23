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
    
    func setupBanerView() {
        banerViewController = BanerViewController(nibName: "BanerViewController", bundle: nil)
        self.addChild(banerViewController)
        self.view.addSubview(banerViewController.view)
        let width: CGFloat = 200
        let height: CGFloat = 200
        banerViewController.view.frame = CGRect(x: view.center.x / 2, y: view.center.y - (height / 2), width: width, height: height)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        banerViewController.backImageView.addGestureRecognizer(panGR)
        banerViewController.backImageView.isUserInteractionEnabled = true
        
//        banerViewController.view.clipsToBounds = true
    }
    
    func setupDescriptionView() {
        descriptionViewController = DescriptionViewController(nibName: "DescriptionViewController", bundle: nil)
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
    
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextStep, duration: 0.5)
        case .changed:
            updateIntarectiveTransition(fractionCompleted: 0)
        case .ended:
            continueInteractionTransition()
        default:
            break
        }
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        setupBanerView()
        setupDescriptionView()
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextStep, duration: 0.5)
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
            
            let banerAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    let width: CGFloat = self.view.bounds.height
                    let height: CGFloat = self.view.bounds.height
                    self.banerViewController.view.frame = CGRect(
                        x: self.view.center.x - (width / 2),
                        y: self.view.center.y - (height / 2),
                        width: width,
                        height: height)
                case .collapsed:
                    self.banerViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            banerAnimator.startAnimation()
            runningAnimations.append(banerAnimator)
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
