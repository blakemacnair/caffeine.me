//
//  MapViewModel.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import class MapKit.MKPointAnnotation

enum MapViewState {
    case loading
    case ready(annotations: [MKPointAnnotation])
}

enum MapViewAction {
    case viewLoaded
}

protocol MapViewModelProtocol {
    var actions: PublishRelay<MapViewAction> { get }
    var state: Driver<MapViewState> { get }
}

struct MapViewModel {
}
