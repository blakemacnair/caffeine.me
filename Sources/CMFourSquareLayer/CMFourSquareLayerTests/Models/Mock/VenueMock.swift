//
//  VenueMock.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

@testable import CMFourSquareLayer

extension Location {
    static let mock = Location(address: "123 hello blvd",
                               lat: 1.0,
                               lng: 1.0,
                               distance: 10,
                               postalCode: "12345",
                               cc: "US",
                               country: "United States",
                               state: "IL",
                               city: "Chicago",
                               formattedAddress: ["123 hello blvd", "Chicago, IL 12345"])
}

extension Venue {
    static let mock = Venue(id: "1",
                            name: "The venue",
                            location: .mock,
                            categories: [.CoffeeShop])
}
