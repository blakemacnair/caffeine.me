//
//  AppDelegate.swift
//  caffeine.me
//

import UIKit
import RxSwift
import CMViewLayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator!

    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {

            window = UIWindow()

            appCoordinator = AppCoordinator(window: window!)
            appCoordinator.start()
                .emit()
                .disposed(by: disposeBag)

            return true
    }
}

