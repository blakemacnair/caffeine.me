//
//  VenueDetailViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

import struct CMFourSquareLayer.Venue

protocol VenueDetailViewControllerProtocol {
    var state: BehaviorRelay<VenueDetailViewState> { get }
    var uiEvents: PublishRelay<VenueDetailViewAction> { get }
}

final class VenueDetailViewController: UIViewController, VenueDetailViewControllerProtocol {
    let state = BehaviorRelay<VenueDetailViewState>(value: .loading)
    let uiEvents = PublishRelay<VenueDetailViewAction>()
}
