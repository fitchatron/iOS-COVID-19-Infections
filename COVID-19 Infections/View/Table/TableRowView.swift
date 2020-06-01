//
//  TableRowView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct TableRowView: View {
    
    var vm: CovidInfectionsViewModel
    var width: CGFloat
    
    var columnOne: String
    var columnTwo: String
    var columnThree: String
    var columnFour: String
    
    var body: some View {
        HStack(spacing: 2) {
            Group {
                VerticalTableBorder()
                Text(columnOne)
                    .frame(width: width * 0.2, height: 60, alignment: .leading)
                VerticalTableBorder()
                Text(columnTwo)
                    .frame(width: width * 0.25, height: 60, alignment: .leading)
                VerticalTableBorder()
                Text(columnThree)
                    .frame(width: width * 0.25, height: 60, alignment: .leading)
                VerticalTableBorder()
                Text(columnFour)
                    .frame(width: width * 0.25, height: 60, alignment: .leading)
                VerticalTableBorder()
            }
        }
    }
}
