//
//  VenueAnnotation.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import MapKit
import CMFourSquareLayer

public class VenueAnnotation: NSObject, MKAnnotation {
    public let coordinate: CLLocationCoordinate2D

    public let title: String?
    public let subtitle: String?

    public let venue: Venue

    public init?(_ venue: Venue) {
        guard let lat = venue.location.lat, let long = venue.location.lng else { return nil }
        self.venue = venue
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.title = venue.name
        self.subtitle = venue.location.address
    }
}
