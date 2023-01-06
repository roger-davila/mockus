//
//  Place.swift
//  Near
//
//  Created by Roger Davila on 1/3/23.
//

import Foundation

struct Cart: Identifiable {
    var id:String = UUID().uuidString
    var products: [Product]
}
