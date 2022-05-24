//
//  Configure.swift
//  PracticeFor7egend
//
//  Created by user on 22.05.2022.
//

import Foundation
import UIKit

struct Configure {
    
    static var shared = Configure()
    
    
//    func setupView(sender: ViewController, nibController: UIViewController) {
//        switch nibController {
//        case let banerVC as BanerViewController: print("BanerViewController")
//        case let desriptionVC as DescriptionViewController: print("DescriptionViewController")
//        default: break
//        }
//    }
//    
//    private func setupBanerView() {
//        self.addChild(banerViewController)
//        self.view.addSubview(banerViewController.view)
//        
//        let backView = banerViewController.backImageView!
//        banerViewController.view.addSubview(backView)
//        backView.translatesAutoresizingMaskIntoConstraints = false
//        backView.alpha = 0
//        let screenWidth: CGFloat = view.frame.width
//        let screenHeight: CGFloat = view.frame.height
//        backView.frame = CGRect(
//            x: view.center.x - ((screenWidth - 100) / 2),
//            y: view.center.y - ((screenHeight - 80) / 2),
//            width: screenWidth - 50,
//            height: screenHeight - 100
//        )
//        
//        configView(view: banerViewController.timingLabel!)
//        configView(view: banerViewController.titleLabel!)
//        configView(view: banerViewController.xMarkImageView!)
//        configView(view: banerViewController.iconImageView!)
//        configView(view: banerViewController.editLabel!)
//        
//        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
//        banerViewController.backImageView.addGestureRecognizer(panGR)
//        banerViewController.backImageView.isUserInteractionEnabled = true
//        
//        let xmarkTapGR = UITapGestureRecognizer(target: self, action: #selector(xmarkTaped(recognizer:)))
//        banerViewController.xMarkImageView.addGestureRecognizer(xmarkTapGR)
//        banerViewController.xMarkImageView.isUserInteractionEnabled = true
//    }
//    
//    private func configView(view: UIView) {
//        let newView = view
//        banerViewController.view.addSubview(newView)
//        newView.translatesAutoresizingMaskIntoConstraints = false
//        newView.alpha = 0
//    }
    
}
