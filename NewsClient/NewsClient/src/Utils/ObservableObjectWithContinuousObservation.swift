//
//  ObservableObjectExtension.swift
//  NewsClient
//
//  Created by Daria Kolpakova on 18.03.2025.
//


import Foundation

extension ObservableObject {
    func withContinuousObservation<T>(
        of value: @escaping @autoclosure () -> T,
        execute: @escaping (T) -> Void
    ) {
        withObservationTracking {
            execute(value())
        } onChange: {
            DispatchQueue.main.async {
                self.withContinuousObservation(
                    of: value(),
                    execute: execute
                )
            }
        }
    }
}
