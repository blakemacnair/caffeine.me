//
//  VenueDetailCoordinator.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import struct CMFourSquareLayer.Venue

final class VenueDetailCoordinator: BaseCoordinator<Void> {
    private let viewController: VenueDetailViewControllerProtocol & UIViewController
    private let viewModel: VenueDetailViewModelProtocol

    init(venue: Venue) {
        self.viewController = VenueDetailViewController()
        self.viewModel = VenueDetailViewModel(venue: venue)
    }

    override func start() -> Signal<Void> {
        return Signal.never()
    }
}
