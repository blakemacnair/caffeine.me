//
//  MapViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import MapKit
import RxMKMapView

protocol MapViewControllerProtocol {
    var state: BehaviorRelay<MapViewState> { get }
    var uiEvents: PublishRelay<MapViewAction> { get }
}

final class MapViewController: UIViewController & MapViewControllerProtocol {
    let state = BehaviorRelay<MapViewState>(value: .loading)
    let uiEvents = PublishRelay<MapViewAction>()

    private let rootView = MKMapView()

    private let annotationsRelay = BehaviorRelay<[MKPointAnnotation]>(value: [])
    private let disposeBag = DisposeBag()

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        annotationsRelay
            .asDriver()
            .drive(rootView.rx.annotations)
            .disposed(by: disposeBag)

        driveState()
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        startUpdatingUserLocation()
    }

    // MARK: - Private

    private func startUpdatingUserLocation() {
        rootView.setUserTrackingMode(.follow, animated: true)
        rootView.rx.didUpdateUserLocation
            .subscribe(onNext: { userloc in
                self.rootView.setUserTrackingMode(.follow, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func driveEventsRelay() {
        // TODO: Implement user interactions
    }

    private func driveState() {
        state
            .asDriver()
            .drive(onNext: { [unowned self] state in
                self.configureView(for: state)
            })
            .disposed(by: disposeBag)
    }

    private func configureView(for state: MapViewState) {
        switch state {
        case .loading:
            break
        case .ready(let userPlacemark, let annotations, _):
            self.annotationsRelay.accept(annotations)

            if let userPlacemark = userPlacemark, let location = userPlacemark.location {
                let region = generateRegion(from: location.coordinate)
                self.rootView.setRegion(region, animated: true)
            }
        }
    }

    private func generateRegion(from coord: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: coord,
                                  latitudinalMeters: 1000,
                                  longitudinalMeters: 1000)
    }
}
