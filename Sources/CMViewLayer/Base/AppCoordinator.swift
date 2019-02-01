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

    public init(window: UIWindow) {
        self.window = window
    }

    public override func start() -> Signal<Void> {
        navigationController.isNavigationBarHidden = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let sampleVC = UIViewController()
        sampleVC.view.backgroundColor = .magenta
        navigationController.setViewControllers([sampleVC], animated: false)

        return Signal.never()
    }
}
