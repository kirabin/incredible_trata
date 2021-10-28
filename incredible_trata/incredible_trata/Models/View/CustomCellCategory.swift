//
//  CustomCellCategoriy.swift
//  incredible_trata
//
//  Created by Aristova Alina on 26.10.2021.
//

import Foundation

enum CustomCellCategory {
    case transport, home, shop, trip
    var title: String {
        switch self {
        case .transport:
            return "Transport"
        case .home:
            return "Home"
        case .shop:
            return "Shop"
        case .trip:
            return "Trip"
        }
    }
    var imageName: String {
        switch self {
        case .transport:
            return "car.fill"
        case .home:
            return "house"
        case .shop:
            return "person.2"
        case .trip:
            return "airplane"
        }
    }
    
}
