//
//  CovidInfectionsViewModel.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 2/4/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation
import CSV
import SwiftUI

class CovidInfectionsViewModel: ObservableObject {
    
    var service = Service()
    
    let alphaCountryCodes = Bundle.main.decode([AlphaCountryCode].self, from: "alpha_country_codes.json")
    var localities = [LocalityStats]()
    var abbreviatedAusStates = ["ACT","NSW","NT","QLD","SA","TAS","VIC","WA"]
    
    @Published var australiaLocalities = [LocalityStats]()
    @Published var countries = [CountryStats]()
    @Published var total = Total(confirmed: 0, deaths: 0, recovered: 0, active: 0)
    @Published var ausTotal = Total(confirmed: 0, deaths: 0, recovered: 0, active: 0)
    @Published var isErrorShowing = false
    @Published var loadingWheelShowing = false
    
    fileprivate let dispatchGroup = DispatchGroup()
    let yesterday = Date().addingTimeInterval(60 * 60 * 24 * 1)
    let dayBeforeYesterday = Date().addingTimeInterval(60 * 60 * 24 * -2)
    
    var countryNames = Set<String>()
    
    init() {
        handleCallFromViewModel()
    }
    
    func handleCallFromViewModel() {
        self.loadingWheelShowing = true
        self.service.fetchCSVData(dt: self.yesterday) { result in
            switch result {
            case .success(let csvString):
                DispatchQueue.main.async {
                    self.cleanseCsvData(csvString)
                    self.loadingWheelShowing = false
                }
            case .failure(let error):
                if error == .invalidURL {
                    self.service.fetchCSVData(dt: self.dayBeforeYesterday) { (result) in
                        switch result {
                        case .success(let csvString):
                            DispatchQueue.main.async {
                                self.cleanseCsvData(csvString)
                                self.loadingWheelShowing = false
                            }
                        case .failure(let error):
                            //error handle
                            DispatchQueue.main.async {
                                print(error.rawValue)
                                self.loadingWheelShowing = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func cleanseCsvData(_ csv: String) {
        
        DispatchQueue.main.async {
            self.emptyVariables()
            let lines = try! CSVReader(string: csv)
            
            while let localities = lines.next() {
                if localities[0] != "FIPS" {
                    var countryCodeData = self.alphaCountryCodes.filter{$0.countryRegion == localities[3]}
                    if countryCodeData.isEmpty {
                        countryCodeData.append(AlphaCountryCode(countryRegion: "Not Found", alphaTwoCode: "ZZ", alphaThreeCode: "ZZZ"))
                    }
                    let locality = LocalityStats(provinceState: localities[2], countryRegion: localities[3], lastUpdate: localities[4], lat: localities[5], long_: localities[6], confirmed: Int(localities[7]) ?? 0, deaths: Int(localities[8]) ?? 0, recovered: Int(localities[9]) ?? 0, active: Int(localities[10]) ?? 0, alphaTwoCode: countryCodeData[0].alphaTwoCode, alphaThreeCode: countryCodeData[0].alphaThreeCode)
                    self.localities.append(locality)
                    self.countryNames.insert(localities[3])
                }
            }
            self.sumTotals()
            self.mapToCountryData()
            self.sumAusTotals()
            self.mapToAustraliaData()
        }
    }
    
    func emptyVariables() {
        localities.removeAll()
        countries.removeAll()
    }
    
    func sumTotals() {
        total.confirmed = localities.reduce(0, {$0 + $1.confirmed})
        total.active = localities.reduce(0, {$0 + $1.active})
        total.deaths = localities.reduce(0, {$0 + $1.deaths})
        total.recovered = localities.reduce(0, {$0 + $1.recovered})
    }
    
    func mapToCountryData() {
        countryNames.forEach { country in
            let filteredList = localities.filter{$0.countryRegion == country}
            let countryData = CountryStats(countryRegion: country, confirmed: filteredList.reduce(0, {$0 + $1.confirmed}), deaths: filteredList.reduce(0, {$0 + $1.deaths}), recovered: filteredList.reduce(0, {$0 + $1.recovered}), active: filteredList.reduce(0, {$0 + $1.active}), alphaTwoCode: filteredList[0].alphaTwoCode, alphaThreeCode: filteredList[0].alphaThreeCode)
            self.countries.append(countryData)
        }
        self.countries.sort{($0.confirmed) > ($1.confirmed) }
    }
    
    func sumAusTotals() {
        ausTotal.confirmed = australiaLocalities.reduce(0, {$0 + $1.confirmed})
        ausTotal.active = australiaLocalities.reduce(0, {$0 + $1.active})
        ausTotal.deaths = australiaLocalities.reduce(0, {$0 + $1.deaths})
        ausTotal.recovered = australiaLocalities.reduce(0, {$0 + $1.recovered})
    }
    
    func mapToAustraliaData() {
        australiaLocalities = localities.filter{$0.countryRegion == "Australia"}
        australiaLocalities.sort{($0.provinceState) < ($1.provinceState) }
        var x = 0
        while x < australiaLocalities.count {
            australiaLocalities[x].provinceState = abbreviatedAusStates[x]
            x += 1
        }
    }
}

/*
let dateFormatter = DateFormatter()

 func dateToString(date: Date) -> String {
     dateFormatter.locale = Locale(identifier: "en_AU")
     dateFormatter.dateFormat = "MM-dd-yyyy"
     let str = dateFormatter.string(from: date)
     return str
 }
 
func fetchCSVData(dt: Date) {
    
    emptyVariables()
    
    let dateStr = dateToString(date: dt)
    print(dateStr)
    let apiURL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/\(dateStr).csv"
    guard let url = URL(string: apiURL) else {
        print("error reacting url", apiURL)
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, res, err) in
        self.dispatchGroup.enter()
        if let err = err {
            self.dispatchGroup.leave()
            print("error starting URL Session: ", err)
            return
        }
        
        if let httpResponse = res as? HTTPURLResponse {
            print(httpResponse.statusCode)
            if httpResponse.statusCode == 404 {
                self.dispatchGroup.leave()
                print("url not valid: ", httpResponse.statusCode)
                self.fetchCSVData(dt: self.dayBeforeYesterday)
                return
            }
        }
        
        guard let data = data else { return }
        
        guard let str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else { return }
        
        let lines = try! CSVReader(string: str)
        while let localities = lines.next() {
            if localities[0] != "FIPS" {
                var countryCodeData = self.alphaCountryCodes.filter{$0.countryRegion == localities[3]}
                if countryCodeData.isEmpty {
                    countryCodeData.append(AlphaCountryCode(countryRegion: "Not Found", alphaTwoCode: "ZZ", alphaThreeCode: "ZZZ"))
                }
                let locality = LocalityStats(provinceState: localities[2], countryRegion: localities[3], lastUpdate: localities[4], lat: localities[5], long_: localities[6], confirmed: Int(localities[7]) ?? 0, deaths: Int(localities[8]) ?? 0, recovered: Int(localities[9]) ?? 0, active: Int(localities[10]) ?? 0, alphaTwoCode: countryCodeData[0].alphaTwoCode, alphaThreeCode: countryCodeData[0].alphaThreeCode)
                self.localities.append(locality)
                self.countryNames.insert(localities[3])
            }
        }
        self.dispatchGroup.leave()
        
        self.dispatchGroup.notify(queue: .main) {
            self.sumTotals()
            self.mapToCountryData()
            self.sumAusTotals()
            self.mapToAustraliaData()
        }
    }.resume()
}
*/
