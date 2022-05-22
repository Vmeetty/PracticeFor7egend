//
//  Service.swift
//  PracticeFor7egend
//
//  Created by user on 22.05.2022.
//

import Foundation
import UIKit

struct Service {
    
    static var shared = Service()
    
    
    func animateCellsFor(tableView: UITableView, by gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }

        let loc = gesture.location(in: tableView)
        guard let touchedCellIndex = tableView.indexPathForRow(at: loc) else { return }
        let n = tableView.numberOfRows(inSection: 0)
        guard touchedCellIndex.row < n - 1 else { return }

        if gesture.translation(in: tableView).y < 0 {
            for (index, cell) in tableView.visibleCells.enumerated() {
                guard let ip = tableView.indexPath(for: cell) else { return }
                if ip.row > touchedCellIndex.row {
                    cell.transform = CGAffineTransform(translationX: 0.0, y: -gesture.velocity(in: tableView).y * 0.02 * tanh(CGFloat(index)))
                    UIView.animate(withDuration: 0.05 * Double(index), delay: 0.0) {
                        cell.transform = CGAffineTransform.identity
                    }
                }
            }
        } else {
            for (index, cell) in tableView.visibleCells.reversed().enumerated() {
                guard let ip = tableView.indexPath(for: cell) else { return }
                if ip.row < touchedCellIndex.row {
                    cell.transform = CGAffineTransform(translationX: 0.0, y: -gesture.velocity(in: tableView).y * 0.02 * tanh(CGFloat(index)))
                    UIView.animate(withDuration: 0.05 * Double(index), delay: 0.0) {
                        cell.transform = CGAffineTransform.identity
                    }
                }
            }
        }
    }
    
}
