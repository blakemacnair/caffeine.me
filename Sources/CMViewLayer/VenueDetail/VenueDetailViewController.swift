//
//  VenueDetailViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa

protocol VenueDetailViewControllerProtocol {
    var state: BehaviorRelay<VenueDetailViewState> { get }
    var uiEvents: PublishRelay<VenueDetailViewAction> { get }
}

final class VenueDetailViewController: UIViewController {
    
}
