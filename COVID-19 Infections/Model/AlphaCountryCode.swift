//
//  AlphaCountryCode.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 26/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation

struct AlphaCountryCode: Decodable {
    var countryRegion: String
    var alphaTwoCode: String
    var alphaThreeCode: String
}
