//
//  SwiftUIView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 25/3/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct CovidInfectionsView: View {
    
    @StateObject private var vm = CovidInfectionsViewModel()
    
    @State var selection = 0
    //var selections = ["Graph", "Table", "Australia"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Group {
                    ScrollView {
                        ZStack {
                            VStack {
                                if !self.vm.countries.isEmpty {
                                    HeadingView(vm: vm, selection: $selection)
                                    if self.selection == 0 {
                                        GraphView(vm: self.vm, multiplier: geometry.size.height)
                                    }
                                    else if self.selection == 1 {
                                        CountryTableView(vm: vm, size: geometry.size)
                                    } else {
                                        AusTableView(vm: vm, size: geometry.size)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width)
                            
                            if vm.loadingWheelShowing {
                                ProgressView("Fetching latest data...")
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle("COVID-19 Data")
            .navigationBarItems(trailing: Button(action: {
                self.vm.handleCallFromViewModel()
            }, label: {
                HStack {
                    Spacer()
                    Text("Refresh Data")
                        .frame(height: 30)
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(6)
            })
            .disabled(self.vm.countries.isEmpty ? true : false)
            )
        }
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CovidInfectionsView()
    }
}
