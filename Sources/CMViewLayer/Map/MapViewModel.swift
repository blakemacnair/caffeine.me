//
//  MapViewModel.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MapViewModelProtocol {
    var actions: PublishRelay<MapViewAction> { get }
    var state: Driver<MapViewState> { get }
    var coordinatorRequests: Driver<MapCoordinatorRequest> { get }
}

struct MapViewModel: MapViewModelProtocol {
    let actions = PublishRelay<MapViewAction>()
    let state: Driver<MapViewState>
    let coordinatorRequests: Driver<MapCoordinatorRequest>

    init() {
        state = actions.toViewState(initialState: .loading)
        coordinatorRequests = actions.toCoordinatorRequest()
    }
}

extension ObservableType where E == MapViewAction {
    func toViewState(initialState: MapViewState) -> Driver<MapViewState> {
        return self
            .scan(initialState, accumulator: MapViewState.reduce)
            .asDriver(onErrorJustReturn: .ready(userPlacemark: nil, annotations: [], error: .unknown))
            .startWith(initialState)
    }
}

extension MapViewState {
    static func reduce(state: MapViewState, action: MapViewAction) -> MapViewState {
        switch (state, action) {
        case (_, .locationServicesUpdated(let placemark, let annotations)):
            return .ready(userPlacemark: placemark, annotations: annotations, error: nil)
        case (_, .annotationTapped(_)):
            return state
        }
    }
}

extension ObservableType where E == MapViewAction {
    func toCoordinatorRequest() -> Driver<MapCoordinatorRequest> {
        return self
            .map { action -> MapCoordinatorRequest? in
                switch action {
                case .locationServicesUpdated:
                    return nil
                case .annotationTapped(let venueAnnotation):
                    return .displayVenueDetails(venueAnnotation.venue)
                }
            }
            .filter { $0 != nil }
            .map { $0! }
            .asDriver(onErrorJustReturn: .displayError(.unknown))
    }
}
