//
//  SwiftUIView.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 25/3/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

struct CovidInfectionsView: View {
    
    @ObservedObject var vm = CovidInfectionsViewModel()
    
    @State var selection = 0
    var selections = ["Graph", "Table", "Australia"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Group {
                    ScrollView {
                        ZStack {
                            VStack {
                                if !self.vm.countries.isEmpty {
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
                                    
                                    if self.selection == 0 {
                                        GraphView(vm: self.vm, multiplier: geometry.size.height)
                                    }
                                    else if self.selection == 1 {
                                        VStack(alignment: .center) {
                                            HorizontalTableBorder(width: geometry.size.width)
                                            TableRowView(vm: self.vm, width: geometry.size.width, columnOne: "Country", columnTwo: "Confirmed", columnThree: "Active", columnFour: "Deaths")
                                            HorizontalTableBorder(width: geometry.size.width)
                                            ForEach(0...10, id: \.self) { item in
                                                HStack(spacing: 2) {
                                                    Group {
                                                        VerticalTableBorder()
                                                        Text(self.vm.countries[item].countryRegion)
                                                            .frame(width: geometry.size.width * 0.2, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(self.vm.countries[item].confirmed)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(self.vm.countries[item].active)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(self.vm.countries[item].deaths)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                    }
                                                }
                                            }
                                            HorizontalTableBorder(width: geometry.size.width)
                                        }
                                    } else {
                                        VStack(alignment: .center) {
                                            HorizontalTableBorder(width: geometry.size.width)
                                            TableRowView(vm: self.vm, width: geometry.size.width, columnOne: "State", columnTwo: "Confirmed", columnThree: "Active", columnFour: "Deaths")
                                            HorizontalTableBorder(width: geometry.size.width)
                                            ForEach(self.vm.australiaLocalities) { locality in
                                                HStack(spacing: 2) {
                                                    Group {
                                                        VerticalTableBorder()
                                                        Text(locality.provinceState)
                                                            .frame(width: geometry.size.width * 0.2, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(locality.confirmed)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(locality.active)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                        Text("\(locality.deaths)")
                                                            .frame(width: geometry.size.width * 0.25, height: 60, alignment: .leading)
                                                        VerticalTableBorder()
                                                    }
                                                }
                                            }
                                            HorizontalTableBorder(width: geometry.size.width)
                                        }
                                    }
                                }
                            }
                            .frame(width: geometry.size.width)
                            ActivityIndicator(shouldAnimate: self.$vm.loadingWheelShowing)
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

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
