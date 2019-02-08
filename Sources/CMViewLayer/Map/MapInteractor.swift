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
import class CoreLocation.CLLocation
import typealias CoreLocation.CLLocationDistance
import enum CoreLocation.CLAuthorizationStatus

enum MapInteractorState: Equatable {
    case loading
    case locationServicesNotAuthorized
    case locationServicesUnavailable
    case ready(userPlacemark: CLPlacemark, annotations: [VenueAnnotation])
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

    private let distanceFilter: CLLocationDistance = 100

    private let venuesRelay = BehaviorRelay<[Venue]>(value: [])

    private let locationRelay: CMLocationRelayProtocol
    private let fourSquareRelay: CMFourSquareRelayProtocol

    private let disposeBag = DisposeBag()

    init(locationRelay: CMLocationRelayProtocol,
         fourSquareRelay: CMFourSquareRelayProtocol) {
        self.locationRelay = locationRelay
        self.fourSquareRelay = fourSquareRelay

        let seed: CLLocation? = CLLocation(latitude: 0, longitude: 0)

        let placemarkSignificantChange = locationRelay.placemark.map { $0.location }
            .scan(seed,
                  accumulator: { [distanceFilter] seed, newValue -> CLLocation? in
                    guard let seed = seed, let newLocation = newValue else { return newValue }
                    let shouldUpdate = newLocation.distance(from: seed) > distanceFilter
                    return shouldUpdate ? newValue : seed
            })
            .distinctUntilChanged()
            .do(onNext: { [unowned self] _ in
                self.refreshVenues()
            })
            .withLatestFrom(locationRelay.placemark)


        Observable.combineLatest(placemarkSignificantChange,
                                 venuesRelay.asObservable())
            .map { (arg) -> MapInteractorState in
                let (placemark, venues) = arg
                let annotations = venues.compactMap { VenueAnnotation($0) }
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
            .take(1)
            .flatMapLatest { [unowned self] location -> Observable<[Venue]> in
                return self.fourSquareRelay.coffeeShopsNear(location: location,
                                                            limit: 10,
                                                            radius: 1000)
            }
            .bind(to: self.venuesRelay)
            .disposed(by: disposeBag)
    }
}
