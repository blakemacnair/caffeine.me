//
//  AppCoordinator.swift
//  caffeine.me
//

import RxSwift
import RxCocoa
import UIKit

import CMLocationLayer

public final class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let navigationController = UINavigationController()

    private let locationRelay: CMLocationRelayProtocol = CMLocationRelay()

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

        locationRelay.requestAuthorization()
            .debug("AUTH STATUS")
            .filter { auth in
                guard case .authorizedWhenInUse = auth else { return false }
                return true
            }
            .subscribe(onNext: { [unowned self] auth in
                self.locationRelay.startUpdatingLocation()
                self.locationRelay.startUpdatingHeading()
            })
            .disposed(by: self.disposeBag)

        locationRelay.placemark.debug("PLACEMARK")
            .subscribe()
            .disposed(by: disposeBag)

        locationRelay.heading.debug("HEADING")
            .subscribe()
            .disposed(by: disposeBag)

        return Signal.never()
    }
}
