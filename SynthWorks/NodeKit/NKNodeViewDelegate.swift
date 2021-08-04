//
//  NKNodeViewDelegate.swift
//  NKNodeViewDelegate
//
//  Created by Riccardo Persello on 03/08/21.
//

import Foundation

public protocol NKNodeViewDelegate {
    func dragStarted(for node: NKNodeView, from startCoordinate: NKCoordinate)
    func dragEnded(for node: NKNodeView, from startCoordinate: NKCoordinate, to endCoordinate: NKCoordinate)
}
