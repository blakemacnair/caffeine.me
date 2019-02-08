//
//  VenueDetailViewModel.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

protocol VenueDetailViewModelProtocol {
    var actions: PublishRelay<VenueDetailViewAction> { get }
    var state: Driver<VenueDetailViewState> { get }
    var coordinatorRequests: Driver<VenueDetailCoordinatorRequest> { get }
}

final class VenueDetailViewModel {
    
}
