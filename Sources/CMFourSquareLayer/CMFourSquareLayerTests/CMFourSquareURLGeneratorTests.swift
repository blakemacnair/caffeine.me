//
//  CMFourSquareURLGeneratorTests.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import XCTest
@testable import CMFourSquareLayer

class CMFourSquareURLGeneratorTests: XCTestCase {
    func testGenerateVenueSearchURL() {
        let expectedURLString = "https://api.foursquare.com/v2/venues/search"
        let expectedURL = URL(baseUrl: expectedURLString)
        let actualURL = CMFourSquareURLGenerator.venueSearchEndpoint()
        XCTAssertEqual(expectedURL, actualURL)
    }

    func testGenerateVenueSearchURLWithParams() {
        let expectedURLString = "https://api.foursquare.com/v2/venues/search"
        let parameters = ["client_id": "123",
                          "client_secret": "123"]
        var components = URLComponents(string: expectedURLString)
        components?.queryItems = parameters.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }

        let actualURL = CMFourSquareURLGenerator.venueSearchEndpoint(parameters: parameters)
        XCTAssertEqual(components?.url, actualURL)
    }
}
