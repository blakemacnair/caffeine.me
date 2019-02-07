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
}
