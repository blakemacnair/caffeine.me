//
//  CMFourSquareURLGenerator.swift
//  CMFourSquareLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

private enum FourSquareAPIComponent: String {
    case venues
    case search
}

private extension URL {
    mutating func appendPathComponent(_ pathComponent: FourSquareAPIComponent) {
        self.appendPathComponent(pathComponent.rawValue)
    }
}

public final class CMFourSquareURLGenerator {
    static let baseURLString = "https://api.foursquare.com/v2"

    static func venueSearchEndpoint(parameters: [String: String] = [:]) -> URL {
        var url = URL(baseUrl: baseURLString, parameters: parameters)!
        url.appendPathComponent(.venues)
        url.appendPathComponent(.search)
        return url
    }
}
