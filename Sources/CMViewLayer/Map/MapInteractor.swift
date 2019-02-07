//
//  MapInteractor.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import CMLocationLayer
import CMFourSquareLayer

import class CoreLocation.CLPlacemark
import enum CoreLocation.CLAuthorizationStatus
import class MapKit.MKPointAnnotation

enum MapInteractorState: Equatable {
    case loading
    case locationServicesNotAuthorized
    case locationServicesUnavailable
    case ready(userPlacemark: CLPlacemark, annotations: [MKPointAnnotation])
}

protocol MapInteractorProtocol {
    var state: Observable<MapInteractorState> { get }

    func startLocationServies()
    func refreshVenues()
}

final class MapInteractor: MapInteractorProtocol {
    var state: Observable<MapInteractorState> {
        return stateRelay.asObservable()
    }
    private let stateRelay = BehaviorRelay<MapInteractorState>(value: .loading)

    private let venuesRelay = BehaviorRelay<[Venue]>(value: [])

    private let locationRelay: CMLocationRelayProtocol
    private let fourSquareRelay: CMFourSquareRelayProtocol

    private let disposeBag = DisposeBag()

    init(locationRelay: CMLocationRelayProtocol,
         fourSquareRelay: CMFourSquareRelayProtocol) {
        self.locationRelay = locationRelay
        self.fourSquareRelay = fourSquareRelay

        Observable.combineLatest(locationRelay.placemark, venuesRelay.asObservable())
            .map { (arg) -> MapInteractorState in
                let (placemark, venues) = arg
                let annotations = venues.compactMap { MKPointAnnotation($0) }
                return .ready(userPlacemark: placemark, annotations: annotations)
            }
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }

    func startLocationServies() {
        locationRelay.requestAuthorization()
            .filter { auth in
                guard case .authorizedWhenInUse = auth else { return false }
                return true
            }
            .take(1)
            .subscribe(onNext: { [unowned self] _ in
                self.locationRelay.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }

    func refreshVenues() {
        locationRelay.placemark
            .filter { $0.location != nil }
            .map { $0.location! }
            .flatMapLatest { [unowned self] location -> Observable<[Venue]> in
                return self.fourSquareRelay.coffeeShopsNear(location: location,
                                                            limit: 10,
                                                            radius: 500)
            }
            .bind(to: self.venuesRelay)
            .disposed(by: disposeBag)
    }
}
