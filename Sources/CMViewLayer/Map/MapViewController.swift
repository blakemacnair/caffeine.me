//
//  MapViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/6/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import class MapKit.MKMapView
import protocol MapKit.MKAnnotation
import struct MapKit.MKCoordinateRegion
import struct CoreLocation.CLLocationCoordinate2D
import RxMKMapView

import struct CMFourSquareLayer.Venue

protocol MapViewControllerProtocol {
    var state: BehaviorRelay<MapViewState> { get }
    var uiEvents: PublishRelay<MapViewAction> { get }
}

final class MapViewController: UIViewController & MapViewControllerProtocol {
    let state = BehaviorRelay<MapViewState>(value: .loading)
    let uiEvents = PublishRelay<MapViewAction>()

    private let rootView = MKMapView()

    private let annotationsRelay = BehaviorRelay<[MKAnnotation]>(value: [])
    private let disposeBag = DisposeBag()

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        annotationsRelay
            .asDriver()
            .drive(rootView.rx.annotations)
            .disposed(by: disposeBag)

        driveState()
        driveEventsRelay()
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
        let venueTappedAction = rootView.rx.didSelectAnnotationView
            .map { [unowned self] mkAnnotationView -> VenueAnnotation? in
                self.rootView.deselectAnnotation(mkAnnotationView.annotation, animated: true)
                guard let annotation = mkAnnotationView.annotation as? VenueAnnotation
                    else { return nil }
                return annotation
            }
            .filter { $0 != nil }
            .map { $0! }
            .map { MapViewAction.annotationTapped($0) }

        venueTappedAction.bind(to: uiEvents).disposed(by: disposeBag)
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
