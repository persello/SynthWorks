//
//  NKCoordinate.swift
//  NKCoordinate
//
//  Created by Riccardo Persello on 02/08/21.
//

import Foundation

public struct NKCoordinate: Codable {
    
    static var zero: NKCoordinate = NKCoordinate(x: 0, y: 0)
    
    let x: Int
    let y: Int
}
