//
//  VenueSearchResponseTests.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import XCTest
@testable import CMFourSquareLayer

class VenueSearchResponseTests: XCTestCase {

    func testEncoding() {
        let dictionary = encodeObject(VenueSearchResponse.self, object: VenueSearchResponse.mock)
        XCTAssertNotNil(dictionary["meta"])
        XCTAssertNotNil(dictionary["response"])
    }

    func testDecoding() {
        let response = decodeObject(VenueSearchResponse.self, jsonFileName: "venueSearchResponse")
        XCTAssertEqual(response.meta.code, 200)
        XCTAssertEqual(response.response.venues.count, 30)
    }

}
