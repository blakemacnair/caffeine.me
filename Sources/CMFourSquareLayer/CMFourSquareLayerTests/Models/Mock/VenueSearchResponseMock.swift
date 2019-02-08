//
//  VenueSearchResponseMock.swift
//  CMFourSquareLayerTests
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

@testable import CMFourSquareLayer

extension Meta {
    static let mock = Meta(code: 200, requestId: "123")
}

extension VenueResponse {
    static let mock = VenueResponse(venues: [.mock])
}

extension VenueSearchResponse {
    static let mock = VenueSearchResponse(meta: .mock, response: .mock)
}
