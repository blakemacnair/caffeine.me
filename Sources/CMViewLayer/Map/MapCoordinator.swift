//
//  MapCoordinator.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa
import RxMKMapView
import MapKit

import CMLocationLayer
import CMFourSquareLayer

final class MapCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let viewController: MapViewController
    private let viewModel: MapViewModelProtocol
    private let interactor: MapInteractorProtocol

    private let relay = CMFourSquareRelay()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let locationRelay = CMLocationRelay()
        let fourSquareRelay = CMFourSquareRelay()
        self.interactor = MapInteractor(locationRelay: locationRelay,
                                        fourSquareRelay: fourSquareRelay)
        self.viewModel = MapViewModel(interactor: interactor)
        self.viewController = MapViewController(viewModel: viewModel)

        super.init()
    }

    override func start() -> Signal<Void> {
        startServices()

        navigationController.pushViewController(self.viewController, animated: true)
        return .never()
    }

    private func startServices() {
        // TODO: Remove this debug once we move interactor logic into view model
        interactor.state
            .debug("STATE")
            .subscribe()
            .disposed(by: disposeBag)
        interactor.startLocationServies()
        interactor.refreshVenues()
    }
}
