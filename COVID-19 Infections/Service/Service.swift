//
//  Service.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation

class Service {
    
    fileprivate let dateFormatter = DateFormatter()
    
    fileprivate func dateToString(date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "en_AU")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let str = dateFormatter.string(from: date)
        return str
    }
    
    func fetchCSVData(dt: Date, completion: @escaping (Result<String,RequestError>) -> Void) {
        
        let dateStr = dateToString(date: dt)
        print(dateStr)
        let apiURL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/\(dateStr).csv"
        guard let url = URL(string: apiURL) else {
            print("error reacting url", apiURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                print("error starting URL Session: ", err)
                completion(.failure(.invalidResponse))
                return
            }
            
            if let httpResponse = res as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 404 {
                    print("url not valid: ", httpResponse.statusCode)
                    completion(.failure(.invalidURL))
                    return
                }
            }
            
            guard let data = data else { return }
            
            guard let csvStringResult = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else { return }
            
            completion(.success(csvStringResult))
        }
        .resume()
    }
}
