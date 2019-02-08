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
}

struct MapViewModel: MapViewModelProtocol {
    let actions = PublishRelay<MapViewAction>()

    var state: Driver<MapViewState>

    init() {
        state = actions.toViewState(initialState: .loading)
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

private extension MapViewState {
    static func reduce(state: MapViewState, action: MapViewAction) -> MapViewState {
        switch (state, action) {
        case (_, .locationServicesUpdated(let placemark, let annotations)):
            return .ready(userPlacemark: placemark, annotations: annotations, error: nil)
        }
    }
}
