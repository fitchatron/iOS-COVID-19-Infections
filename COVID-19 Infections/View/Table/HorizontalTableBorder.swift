//
//  HorizontalTableBorder.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct HorizontalTableBorder: View {
    
    var width: CGFloat
    
    var body: some View {
        Spacer()
            .frame(width: width * 0.91, height: 2)
            .background(Color(.systemBackground))
    }
}
