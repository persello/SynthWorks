//
//  NKCoordinate.swift
//  NKCoordinate
//
//  Created by Riccardo Persello on 02/08/21.
//

import Foundation

public struct NKCoordinate: Codable {
    
    public static var zero: NKCoordinate = NKCoordinate(x: 0, y: 0)
    
    let x: Int
    let y: Int
    
    public static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return NKCoordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static prefix func -(coordinate: Self) -> Self {
        return NKCoordinate(x: -coordinate.x, y: -coordinate.y)
    }
    
    public static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return lhs + (-rhs)
    }
    
    public static func *(_ lhs: Self, _ rhs: Double) -> Self {
        return NKCoordinate(x: Int(Double(lhs.x) * rhs), y: Int(Double(lhs.y) * rhs))
    }
    
    public static func /(_ lhs: Self, _ rhs: Double) -> Self {
        return lhs * (1/rhs)
    }
}
