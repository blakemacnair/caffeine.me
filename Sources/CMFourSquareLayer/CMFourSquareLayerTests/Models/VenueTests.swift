//
//  VenueTests.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import XCTest
@testable import CMFourSquareLayer

class VenueTests: XCTestCase {

    func testEncoding() {
        let dictionary = encodeObject(Venue.self, object: Venue.mock)
        XCTAssertEqual(dictionary["id"] as? String, Venue.mock.id)
        XCTAssertEqual(dictionary["name"] as? String, Venue.mock.name)
    }

    func testDecoding() {
        let response = decodeObject(Venue.self, jsonFileName: "venue")
        XCTAssertNotNil(response)
    }

}
