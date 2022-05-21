//
//  Manager.swift
//  PracticeFor7egend
//
//  Created by user on 21.05.2022.
//

import Foundation
import UIKit


struct Manager {
    
    static var shared = Manager()
    
    
    //MARK: - Here we can Load data from database. But not now
    
    mutating func fetchCards() -> [Card]? {
        var cards: Array<Card> = []
        cards.append(Card(
            image: UIImage(named: K.Image.i1)!,
            title: K.Title.t1,
            description: K.Descrip.d1,
            topImage: UIImage(systemName: K.SystemImage.s1)!,
            user1: UIImage(named: K.User.image1),
            user2: nil))
        cards.append(Card(
            image: UIImage(named: K.Image.i2)!,
            title: K.Title.t2,
            description: K.Descrip.d2,
            topImage: UIImage(systemName: K.SystemImage.s2)!,
            user1: UIImage(named: K.User.image2),
            user2: UIImage(named: K.User.image5)))
        cards.append(Card(
            image: UIImage(named: K.Image.i3)!,
            title: K.Title.t3,
            description: K.Descrip.d3,
            topImage: UIImage(systemName: K.SystemImage.s1)!,
            user1: UIImage(named: K.User.image3),
            user2: nil))
        cards.append(Card(
            image: UIImage(named: K.Image.i4)!,
            title: K.Title.t4,
            description: K.Descrip.d4,
            topImage: UIImage(systemName: K.SystemImage.s1)!,
            user1: UIImage(named: K.User.image4),
            user2: nil))
        cards.append(Card(
            image: UIImage(named: K.Image.i5)!,
            title: K.Title.t5,
            description: K.Descrip.d5,
            topImage: UIImage(systemName: K.SystemImage.s2)!,
            user1: UIImage(named: K.User.image5),
            user2: UIImage(named: K.User.image5)))
        cards.append(Card(
            image: UIImage(named: K.Image.i6)!,
            title: K.Title.t6,
            description: K.Descrip.d6,
            topImage: UIImage(systemName: K.SystemImage.s1)!,
            user1: UIImage(named: K.User.image2),
            user2: nil))
        cards.append(Card(
            image: UIImage(named: K.Image.i7)!,
            title: K.Title.t7,
            description: K.Descrip.d7,
            topImage: UIImage(systemName: K.SystemImage.s2)!,
            user1: UIImage(named: K.User.image1),
            user2: nil))
        cards.append(Card(
            image: UIImage(named: K.Image.i8)!,
            title: K.Title.t8,
            description: K.Descrip.d8,
            topImage: UIImage(systemName: K.SystemImage.s2)!,
            user1: UIImage(named: K.User.image4),
            user2: nil))
        
        return cards
    }
    

    
    
//    func getCard(title: String, descrip: String, image: String, user1: String?, user2: String?) -> Card {
//        let imageName = UIImage(systemName: image)!
//        var userImage1: UIImage? = nil
//        var userImage2: UIImage? = nil
//        if let str = user1 {
//           userImage1 = UIImage(named: str)
//        }
//        if let str = user2 {
//            userImage2 = UIImage(named: str)
//        }
//        let card = Card(title: title, description: descrip, topImage: imageName, user1: userImage1, user2: userImage2)
//        return card
//    }
    
    
}
