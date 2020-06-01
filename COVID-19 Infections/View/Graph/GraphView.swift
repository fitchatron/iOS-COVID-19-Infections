//
//  GraphView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct GraphView: View {
    
    var vm: CovidInfectionsViewModel
    var multiplier: CGFloat
    
    var body: some View {
        
        VStack {
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(0...10, id: \.self) { item in
                    VStack {
                        ZStack(alignment: .bottom) {
                            BarView(color: .red, measure: self.vm.countries[item].confirmed, max: self.vm.total.confirmed, multiplier: self.multiplier)
                            BarView(color: .blue, measure: self.vm.countries[item].active, max: self.vm.total.confirmed, multiplier: self.multiplier)
                            BarView(color: .green, measure: self.vm.countries[item].recovered, max: self.vm.total.confirmed, multiplier: self.multiplier)
                            BarView(color: Color(.label), measure: self.vm.countries[item].deaths, max: self.vm.total.confirmed, multiplier: self.multiplier)
                        }
                        Text(self.vm.countries[item].alphaThreeCode ?? "ZZZ").padding(.top, 8)
                            .font(.footnote)
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("Key:")
                    .font(.headline)
                HStack {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color.red)
                        .frame(width: 25, height: 25)
                    Text("Confirmed")
                    Spacer()
                }
                HStack {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 25, height: 25)
                    Text("Active")
                    Spacer()
                }
                HStack {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color.green)
                        .frame(width: 25, height: 25)
                    Text("Recovered")
                    Spacer()
                }
                HStack {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color(.label))
                        .frame(width: 25, height: 25)
                    Text("Deaths")
                    Spacer()
                }
            }.padding(12)
        }
    }
}
