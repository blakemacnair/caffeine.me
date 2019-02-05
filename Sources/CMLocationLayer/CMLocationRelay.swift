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
    var locationServicesEnabled: Observable<Bool> { get }
    var placemark: Observable<CLPlacemark> { get }
    var heading: Observable<CLHeading> { get }

    func requestAuthorization() -> Observable<CLAuthorizationStatus>

    func startUpdatingLocation() -> Bool
    func stopUpdatingLocation()

    func startUpdatingHeading() -> Bool
    func stopUpdatingHeading() -> Bool
}

public final class CMLocationRelay: CMLocationRelayProtocol {

}
