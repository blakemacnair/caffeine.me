//
//  Venue.swift
//  CMFourSquareLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

public struct Location: Equatable & Codable {
    public let address: String?
    public let lat: Double?
    public let lng: Double?
    public let distance: Int?
    public let postalCode: String?
    public let cc: String?
    public let country: String?
    public let state: String?
    public let city: String?
    public let formattedAddress: [String]
}

public struct Venue: Equatable & Codable {
    internal let id: String
    public let name: String

    public let location: Location
    public let categories: [Category]
}
