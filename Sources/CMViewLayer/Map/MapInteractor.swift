//
//  MapInteractor.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import CMLocationLayer
import class CoreLocation.CLPlacemark
import class CoreLocation.CLHeading

enum MapInteractorState: Equatable {
    case loading
    case locationServicesNotAuthorized
    case locationServicesUnavailable
    case ready(userPlacemark: CLPlacemark, userHeading: CLHeading)
}

protocol MapInteractorProtocol {
    var state: BehaviorRelay<MapInteractorState> { get }

    func startLocationServies()
}

final class MapInteractor {

}
