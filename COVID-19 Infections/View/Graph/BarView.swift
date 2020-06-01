//
//  BarView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct BarView: View {
    
    var color: Color
    var measure: Int
    var max: Int
    var multiplier: CGFloat
    
    var body: some View {
        VStack() {
            Spacer()
        }.frame(width: 20, height: calcHeight(measure: measure, max: max, multiplier: multiplier))
            .background(color)
    }
}

func calcHeight(measure: Int, max: Int, multiplier: CGFloat) -> CGFloat {
    
    let height = (CGFloat(measure) / CGFloat(max)) * multiplier
    return height
}
