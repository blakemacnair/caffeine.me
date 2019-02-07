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

final class MapCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let viewController: MapViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = MapViewController()

        super.init()
    }

    override func start() -> Signal<Void> {
        navigationController.pushViewController(self.viewController, animated: true)
        return .never()
    }
}
