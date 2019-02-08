//
//  CMLocationRelay.swift
//  CMLocationLayer
//
//  Created by Blake Macnair on 2/4/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

public protocol CMLocationRelayProtocol {
    var authStatus: Observable<CLAuthorizationStatus> { get }
    var placemark: Observable<CLPlacemark> { get }
    var heading: Observable<CLHeading?> { get }

    func requestAuthorization() -> Observable<CLAuthorizationStatus>

    @discardableResult func startUpdatingLocation() -> Bool
    func stopUpdatingLocation()

    @discardableResult func startUpdatingHeading() -> Bool
    func stopUpdatingHeading()
}

public final class CMLocationRelay: CMLocationRelayProtocol {

    // MARK: - Properties

    public let authStatus: Observable<CLAuthorizationStatus>
    private let authStatusRelay = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)

    public let placemark: Observable<CLPlacemark>

    public let heading: Observable<CLHeading?>

    private let disposeBag = DisposeBag()

    private let manager: CLLocationManager

    // MARK: - Init

    public init() {
        manager = CLLocationManager()

        authStatus = authStatusRelay.asObservable()
        manager.rx
            .didChangeAuthorization
            .map { $0.status }
            .bind(to: authStatusRelay)
            .disposed(by: disposeBag)

        placemark = manager.rx.placemark.throttle(5, scheduler: MainScheduler.instance)
        heading = manager.rx.heading
    }

    // MARK: - Public

    public func requestAuthorization() -> Observable<CLAuthorizationStatus> {
        manager.requestWhenInUseAuthorization()
        return self.authStatus
    }

    @discardableResult public func startUpdatingLocation() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        manager.startUpdatingLocation()
        return true
    }

    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    @discardableResult public func startUpdatingHeading() -> Bool {
        guard CLLocationManager.headingAvailable() else { return false }
        manager.startUpdatingHeading()
        return true
    }

    public func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
}
