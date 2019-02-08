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
    private let navigationController: UINavigationController
    private let viewController: VenueDetailViewControllerProtocol & UIViewController
    private let viewModel: VenueDetailViewModelProtocol

    init(venue: Venue, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = VenueDetailViewController()
        self.viewModel = VenueDetailViewModel(venue: venue)
    }

    override func start() -> Signal<Void> {
        bindRelays()

        let dismissEvent = viewModel.coordinatorRequests
            .filter { $0 == .dismissView }
            .map { _ in return () }
            .asObservable()

        navigationController.present(viewController, animated: true)

        return Observable<Void>.never().takeUntil(dismissEvent).asSignal(onErrorJustReturn: ())
    }

    func bindRelays() {
        viewController.uiEvents
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)

        viewModel.state
            .drive(viewController.state)
            .disposed(by: disposeBag)
    }
}
