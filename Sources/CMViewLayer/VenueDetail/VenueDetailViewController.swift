//
//  VenueDetailViewController.swift
//  CMViewLayer
//
//  Created by Blake Macnair on 2/7/19.
//  Copyright © 2019 Blake Macnair. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit

import struct CMFourSquareLayer.Venue

protocol VenueDetailViewControllerProtocol {
    var state: BehaviorRelay<VenueDetailViewState> { get }
    var uiEvents: PublishRelay<VenueDetailViewAction> { get }
}

final class VenueDetailViewController: UIViewController, VenueDetailViewControllerProtocol {

    // MARK: - Properties

    private let disposeBag = DisposeBag()

    private let rootView = VenueDetailView()

    let state = BehaviorRelay<VenueDetailViewState>(value: .loading)
    let uiEvents = PublishRelay<VenueDetailViewAction>()

    // MARK: = Public

    public override func loadView() {
        self.view = rootView
    }
}

final class VenueDetailView: UIView {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "VENUE"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Public

    convenience init() {
        self.init(frame: .zero)
        setup()
    }

    // MARK: - Private

    private func setup() {
        backgroundColor = .white
        addSubview(titleLabel)

        activateInitialConstraints()
    }

    private func activateInitialConstraints() {
        titleLabel.snp.makeConstraints { mk in
            mk.top.left.right.equalTo(self).inset(8)
        }
    }
}
