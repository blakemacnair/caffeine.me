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

final class MapCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let viewController: UIViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = UIViewController()
        self.viewController.view.backgroundColor = .yellow
    }

    override func start() -> Signal<Void> {
        navigationController.pushViewController(self.viewController, animated: true)
        return .never()
    }
}
