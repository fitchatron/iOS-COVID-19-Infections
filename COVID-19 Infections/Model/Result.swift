//
//  Result.swift
//  COVID-19 Infections
//
//  Created by James Fitch on 30/5/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import Foundation

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

enum RequestError: String, Error {
    case invalidURL = "This URL is invalid"
    case invalidResponse = "This response was invalid"
    case invalidData = "Invalid data received from server. Try again"
}
