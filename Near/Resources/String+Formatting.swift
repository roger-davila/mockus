//
//  String+Formatting.swift
//  Near
//
//  Created by Roger Davila on 1/8/23.
//

import Foundation

public extension String {
    func capitalizeText() -> String {
        let stringArray = self.split(separator: "-")
        let capitalizedArray = stringArray.map{ $0.capitalized }
        return capitalizedArray.joined(separator: " ")
    }
}
