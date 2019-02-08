//
//  MapViewState.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import class CoreLocation.CLPlacemark
import class MapKit.MKPointAnnotation

enum MapViewState {
    case loading
    case ready(annotations: [MKPointAnnotation], error: MapViewError?)

    var annotations: [MKPointAnnotation] {
        switch self {
        case .loading: return []
        case .ready(let annotations, _): return annotations
        }
    }
}

enum MapViewAction {
    case locationServicesUpdated(userPlacemark: CLPlacemark, annotations: [MKPointAnnotation])
}
