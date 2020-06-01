//
//  DailyReport.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 2/4/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation

struct LocalityStats: Identifiable, Hashable {
    var id: String? = UUID().uuidString
    var provinceState: String
    var countryRegion: String
    var lastUpdate: String
    var lat: String
    var long_: String
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var alphaTwoCode: String?
    var alphaThreeCode: String?
}
