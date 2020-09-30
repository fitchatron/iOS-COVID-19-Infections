//
//  CountryTableView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/9/2020.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct CountryTableView: View {
    var vm: CovidInfectionsViewModel
    var size: CGSize
    
    var body: some View {
        VStack(alignment: .center) {
            HorizontalTableBorder(width: size.width)
            TableRowView(vm: self.vm, width: size.width, columnOne: "Country", columnTwo: "Confirmed", columnThree: "Active", columnFour: "Deaths")
            HorizontalTableBorder(width: size.width)
            ForEach(0...10, id: \.self) { item in
                HStack(spacing: 2) {
                    Group {
                        VerticalTableBorder()
                        Text(self.vm.countries[item].countryRegion)
                            .frame(width: size.width * 0.2, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(self.vm.countries[item].confirmed)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(self.vm.countries[item].active)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                        Text("\(self.vm.countries[item].deaths)")
                            .frame(width: size.width * 0.25, height: 60, alignment: .leading)
                        VerticalTableBorder()
                    }
                }
            }
            HorizontalTableBorder(width: size.width)
        }
    }
}
