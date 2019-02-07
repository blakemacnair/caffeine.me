//
//  VenueSearchResponse.swift
//  CMFourSquareLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

public struct VenueResponse: Equatable & Codable {
    public let venues: [Venue]
}

public struct VenueSearchResponse: Equatable & Codable {
    public let meta: Meta
    public let response: VenueResponse
}
