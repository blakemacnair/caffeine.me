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
    private let presentingViewController: UIViewController
    private let viewController: VenueDetailViewControllerProtocol & UIViewController
    private let viewModel: VenueDetailViewModelProtocol

    init(venue: Venue, presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.viewController = VenueDetailViewController()
        self.viewModel = VenueDetailViewModel(venue: venue)
    }

    override func start() -> Signal<Void> {
        bindRelays()

        let wrapperNavController = UINavigationController(rootViewController: viewController)

        let dismissEvent = viewModel.coordinatorRequests
            .filter { $0 == .dismissView }
            .map { _ in return () }
            .do(onNext: { _ in
                wrapperNavController.dismiss(animated: true)
            })
            .asObservable()
            .take(1)

        presentingViewController.present(wrapperNavController, animated: true)

        return dismissEvent.asSignal(onErrorJustReturn: ())
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
