//
//  CountryStats.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 2/4/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation

struct CountryStats: Hashable, Identifiable {
    var id: String = UUID().uuidString
    var countryRegion: String
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var alphaTwoCode: String?
    var alphaThreeCode: String?
}
