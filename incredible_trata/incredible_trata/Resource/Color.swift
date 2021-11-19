//
//  Colors.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 26.10.2021.
//

import UIKit

extension UIColor {

    static func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
}

enum Color {
    static let controlBG = UIColor.color(light: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), dark: #colorLiteral(red: 0.1882352941, green: 0.1764705882, blue: 0.2, alpha: 1))
    static let inputFG = UIColor.color(light: #colorLiteral(red: 0.159709245, green: 0.1699241698, blue: 0.1888181865, alpha: 1), dark: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    static let mainBG = UIColor.color(light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.07843137255, green: 0.06666666667, blue: 0.07843137255, alpha: 1))
    static let addButtonBG = UIColor.color(light: #colorLiteral(red: 0.7424827218, green: 0.2673257291, blue: 0.2850755751, alpha: 1), dark: #colorLiteral(red: 0.8156862745, green: 0.2941176471, blue: 0.3176470588, alpha: 1))
    static let headerButtonBG = UIColor.color(light: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), dark: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1))
    static let iconBG = UIColor.color(light: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), dark: #colorLiteral(red: 0.159709245, green: 0.1699241698, blue: 0.1888181865, alpha: 1))
    static let textBG = UIColor.color(light: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
}
