//
//  MapViewState.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import class CoreLocation.CLPlacemark
import protocol MapKit.MKAnnotation

enum MapViewError: Error, Equatable {
    case notAuthorized
    case servicesNotAvailable
    case unknown
}

enum MapViewState {
    case loading
    case ready(userPlacemark: CLPlacemark?, annotations: [MKAnnotation], error: MapViewError?)

    var annotations: [MKAnnotation] {
        switch self {
        case .loading: return []
        case .ready(_, let annotations, _): return annotations
        }
    }
}

enum MapViewAction {
    case locationServicesUpdated(userPlacemark: CLPlacemark, annotations: [MKAnnotation])
    case annotationTapped(MKAnnotation)
}
