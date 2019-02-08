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
import class CoreLocation.CLLocation
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

    private let annotationsRelay = BehaviorRelay<[VenueAnnotation]>(value: [])
    private let disposeBag = DisposeBag()

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        annotationsRelay
            .asDriver()
            .distinctUntilChanged { lhs, rhs in
                let llocs = lhs.map { $0.venue.location }
                let rlocs = rhs.map { $0.venue.location }
                for lloc in llocs {
                    if !rlocs.contains(lloc) { return true }
                }
                return false
            }
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
                self.rootView.setUserTrackingMode(.none, animated: true)
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
                let coords = annotations.map { $0.coordinate } + [location.coordinate]
                let region = generateRegion(from: coords)
                self.rootView.setRegion(region, animated: true)
            }
        }
    }

    private func generateRegion(from coord: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: coord,
                                  latitudinalMeters: 1000,
                                  longitudinalMeters: 1000)
    }

    private func generateRegion(from coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var avgCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var minCoord: CLLocationCoordinate2D?
        var maxCoord: CLLocationCoordinate2D?
        for coordinate in coordinates {
            if minCoord != nil {
                minCoord!.latitude = min(minCoord!.latitude, coordinate.latitude)
                minCoord!.longitude = min(minCoord!.longitude, coordinate.longitude)
            } else {
                minCoord = coordinate
            }
            if maxCoord != nil {
                maxCoord!.latitude = max(maxCoord!.latitude, coordinate.latitude)
                maxCoord!.longitude = max(maxCoord!.longitude, coordinate.longitude)
            } else {
                maxCoord = coordinate
            }
        }

        avgCoord = CLLocationCoordinate2D(latitude: (minCoord!.latitude + maxCoord!.latitude)/2.0,
                                          longitude: (minCoord!.longitude + maxCoord!.longitude)/2.0)

        let xSpan: Double = {
            let minX = CLLocation(latitude: minCoord!.latitude, longitude: maxCoord!.longitude)
            let maxX = CLLocation(latitude: maxCoord!.latitude, longitude: maxCoord!.longitude)
            return minX.distance(from: maxX)
        }()

        let ySpan: Double = {
            let minY = CLLocation(latitude: minCoord!.latitude, longitude: minCoord!.longitude)
            let maxY = CLLocation(latitude: minCoord!.latitude, longitude: maxCoord!.longitude)
            return minY.distance(from: maxY)
        }()

        let padding: Double = 200

        return MKCoordinateRegion(center: avgCoord, latitudinalMeters: xSpan + padding,
                                  longitudinalMeters: ySpan + padding)
    }
}
