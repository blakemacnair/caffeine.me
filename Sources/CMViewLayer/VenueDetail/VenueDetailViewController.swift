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

    // MARK: - Public

    public override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEvents()

        navigationItem.leftBarButtonItem = rootView.dismissItem

        state.asDriver()
            .drive(onNext: { [unowned self] in self.configureView(for: $0) })
            .disposed(by: disposeBag)
    }

    // MARK: - Private

    private func configureView(for state: VenueDetailViewState) {
        guard case .ready(let venue) = state else { return }
        rootView.titleLabel.text = venue.name
        rootView.subtitleLabel.text = venue.location.formattedAddress.joined(separator: "\n")
    }

    private func bindEvents() {
        let dismissAction = rootView.dismissItem.rx.tap.map { VenueDetailViewAction.tappedExit }
        dismissAction.bind(to: uiEvents)
            .disposed(by: disposeBag)
    }
}

final class VenueDetailView: UIView {

    // MARK: - Properties

    let dismissItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                           target: nil,
                                           action: nil)

    let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "VENUE"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let subtitleLabel: UILabel = { // TODO: ADD ME PLEASE
        let label = UILabel()

        label.text = "ADDRESS"
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Public

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        setup()
    }

    // MARK: - Private

    private func setup() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        activateInitialConstraints()
    }

    private func activateInitialConstraints() {
        titleLabel.snp.makeConstraints { mk in
            mk.top.left.right.equalTo(self.readableContentGuide).inset(8)
        }

        subtitleLabel.snp.makeConstraints { mk in
            mk.left.right.equalTo(self.readableContentGuide).inset(8)
            mk.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
