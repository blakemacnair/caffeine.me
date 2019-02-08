//
//  BaseCoordinator.swift
//  caffeine.me
//

import RxSwift
import RxCocoa

open class BaseCoordinator<Result> {

    let disposeBag = DisposeBag()

    private let identifier = UUID()

    private var childCoordinators = [UUID: Any]()

    public init() {}

    private func store<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    /// Add, retain and `start()` a child coordinator
    ///
    /// - Returns: Result of calling `start()` on the child coordinator.
    open func addChild<T>(_ coordinator: BaseCoordinator<T>) -> Signal<T> {
        store(coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator) },
                onCompleted: { [weak self] in self?.free(coordinator) })
    }

    /// Tells the coordinator to start working.
    ///
    /// - Returns: A signal with the result of the coordinator, if any.
    open func start() -> Signal<Result> {
        fatalError("Start method should be implemented.")
    }
}
