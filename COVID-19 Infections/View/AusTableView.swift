//
//  AusTableView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/9/2020.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct AusTableView: View {
    var vm: CovidInfectionsViewModel
    var size: CGSize
    
    var body: some View {
        VStack(alignment: .center) {
            HorizontalTableBorder(width: size.width)
            TableRowView(vm: self.vm, width: size.width, columnOne: "State", columnTwo: "Confirmed", columnThree: "Active", columnFour: "Deaths")
            HorizontalTableBorder(width: size.width)
            ForEach(self.vm.australiaLocalities) { locality in
                HStack(spacing: 2) {
                    Group {
                        VerticalTableBorder()
                        Text(locality.provinceState)
                            .frame(width: size.width * 0.2, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(locality.confirmed)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(locality.active)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(locality.deaths)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                    }
                }
            }
            HorizontalTableBorder(width: size.width)
        }
    }
}
