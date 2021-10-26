//
//  CustomCellViewModel.swift
//  incredible_trata
//
//  Created by 19663308 on 29.10.2021.
//

import Foundation

struct CustomCellViewModel {
    
    let imageName: String
    let title: String
    let subtitle: String
    let price: Int
    
    init(categories: CustomCellCategory, subtitle: String, price: Int) {
        
        self.title = categories.title
        self.imageName = categories.imageName
        self.subtitle = subtitle
        self.price = price
    }
}
