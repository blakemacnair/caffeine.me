//
//  VenueDetailViewModel.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import struct CMFourSquareLayer.Venue

protocol VenueDetailViewModelProtocol {
    var actions: PublishRelay<VenueDetailViewAction> { get }
    var state: Driver<VenueDetailViewState> { get }
    var coordinatorRequests: Driver<VenueDetailCoordinatorRequest> { get }
}

final class VenueDetailViewModel: VenueDetailViewModelProtocol {
    var actions = PublishRelay<VenueDetailViewAction>()
    var state: Driver<VenueDetailViewState>
    var coordinatorRequests: Driver<VenueDetailCoordinatorRequest>

    init(venue: Venue) {
        state = Observable<VenueDetailViewState>.just(.ready(venue))
            .asDriver(onErrorJustReturn: .loading)

        coordinatorRequests = actions
            .filter { $0 == .tappedExit }
            .map { _ in return VenueDetailCoordinatorRequest.dismissView }
            .asDriver(onErrorJustReturn: .displayError(.unknown))
    }
}
