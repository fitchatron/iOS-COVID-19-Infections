//
//  HeadingView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/9/2020.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct HeadingView: View {
    var vm: CovidInfectionsViewModel
    @Binding var selection: Int
    var selections = ["Graph", "Table", "Australia"]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Total Cases: \(self.vm.total.confirmed)")
                .font(.title)
            Text("Total Deaths: \(self.vm.total.deaths)")
                .font(.title)
            HStack {
                Picker(selection: self.$selection, label: Text("")) {
                    ForEach(0 ..< self.selections.count) {
                        Text(self.selections[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }.padding()
    }
}
