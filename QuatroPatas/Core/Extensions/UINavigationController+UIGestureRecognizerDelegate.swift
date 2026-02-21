//
//  UINavigationController+UIGestureRecognizerDelegate.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/09/25.
//

import Foundation
import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
