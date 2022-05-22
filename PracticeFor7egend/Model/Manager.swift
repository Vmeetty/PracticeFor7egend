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
            shortDescription: K.ShortDescrip.d1,
            icon: UIImage(systemName: K.Icon.s1)!,
            user1: UIImage(named: K.User.image1),
            user2: nil,
            fullDescription: K.FullDescription.fullDes1,
            timing: K.Timing.timing1,
            city: K.City.city1))
        cards.append(Card(
            image: UIImage(named: K.Image.i2)!,
            title: K.Title.t2,
            shortDescription: K.ShortDescrip.d2,
            icon: UIImage(systemName: K.Icon.s2)!,
            user1: UIImage(named: K.User.image2),
            user2: UIImage(named: K.User.image5),
            fullDescription: K.FullDescription.fullDes2,
            timing: K.Timing.timing2,
            city: K.City.city2))
        cards.append(Card(
            image: UIImage(named: K.Image.i3)!,
            title: K.Title.t3,
            shortDescription: K.ShortDescrip.d3,
            icon: UIImage(systemName: K.Icon.s1)!,
            user1: UIImage(named: K.User.image3),
            user2: nil,
            fullDescription: K.FullDescription.fullDes3,
            timing: K.Timing.timing3,
            city: K.City.city3))
        cards.append(Card(
            image: UIImage(named: K.Image.i4)!,
            title: K.Title.t4,
            shortDescription: K.ShortDescrip.d4,
            icon: UIImage(systemName: K.Icon.s1)!,
            user1: UIImage(named: K.User.image4),
            user2: nil,
            fullDescription: K.FullDescription.fullDes4,
            timing: K.Timing.timing4,
            city: K.City.city4))
        cards.append(Card(
            image: UIImage(named: K.Image.i5)!,
            title: K.Title.t5,
            shortDescription: K.ShortDescrip.d5,
            icon: UIImage(systemName: K.Icon.s2)!,
            user1: UIImage(named: K.User.image5),
            user2: UIImage(named: K.User.image5),
            fullDescription: K.FullDescription.fullDes5,
            timing: K.Timing.timing5,
            city: K.City.city5))
        cards.append(Card(
            image: UIImage(named: K.Image.i6)!,
            title: K.Title.t6,
            shortDescription: K.ShortDescrip.d6,
            icon: UIImage(systemName: K.Icon.s1)!,
            user1: UIImage(named: K.User.image2),
            user2: nil,
            fullDescription: K.FullDescription.fullDes6,
            timing: K.Timing.timing6,
            city: K.City.city6))
        cards.append(Card(
            image: UIImage(named: K.Image.i7)!,
            title: K.Title.t7,
            shortDescription: K.ShortDescrip.d7,
            icon: UIImage(systemName: K.Icon.s2)!,
            user1: UIImage(named: K.User.image1),
            user2: nil,
            fullDescription: K.FullDescription.fullDes7,
            timing: K.Timing.timing7,
            city: K.City.city7))
        cards.append(Card(
            image: UIImage(named: K.Image.i8)!,
            title: K.Title.t8,
            shortDescription: K.ShortDescrip.d8,
            icon: UIImage(systemName: K.Icon.s2)!,
            user1: UIImage(named: K.User.image4),
            user2: nil,
            fullDescription: K.FullDescription.fullDes8,
            timing: K.Timing.timing8,
            city: K.City.city8))
        
        return cards
    }

    
    
}
