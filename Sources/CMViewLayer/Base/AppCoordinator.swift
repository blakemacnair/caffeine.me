//
//  AppCoordinator.swift
//  caffeine.me
//

import RxSwift
import RxCocoa
import UIKit

public final class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let navigationController = UINavigationController()

    private let mapCoordinator: MapCoordinator

    public init(window: UIWindow) {
        self.window = window

        self.mapCoordinator = MapCoordinator(navigationController: self.navigationController)
    }

    public override func start() -> Signal<Void> {
        navigationController.isNavigationBarHidden = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        _ = mapCoordinator.start()

        return Signal.never()
    }
}
