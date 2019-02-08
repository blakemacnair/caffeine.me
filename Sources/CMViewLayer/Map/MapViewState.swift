//
//  MapViewState.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import class CoreLocation.CLPlacemark

enum MapViewError: Error, Equatable {
    case notAuthorized
    case servicesNotAvailable
    case unknown
}

enum MapViewState {
    case loading
    case ready(userPlacemark: CLPlacemark?, annotations: [VenueAnnotation], error: MapViewError?)

    var annotations: [VenueAnnotation] {
        switch self {
        case .loading: return []
        case .ready(_, let annotations, _): return annotations
        }
    }
}

enum MapViewAction {
    case locationServicesUpdated(userPlacemark: CLPlacemark, annotations: [VenueAnnotation])
    case annotationTapped(VenueAnnotation)
}
