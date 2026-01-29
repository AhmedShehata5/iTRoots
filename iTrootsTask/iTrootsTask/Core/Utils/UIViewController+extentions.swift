//
//  UIViewController+ُءفثىفهخى.swift
//  NewBazar
//
//  Created by Ahmed on 18/01/2026.
//


import UIKit

extension UIViewController {

    func safeClose(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let nav = self.navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: animated)
            completion?()
        }
        else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: completion)
        }
        else {
            print("⚠️ Unable to close VC: not in NavigationController or Presented modally")
            completion?()
        }
    }
}


import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround(except views: [UIView] = []) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)

        objc_setAssociatedObject(
            self,
            &AssociatedKeys.excludedViews,
            views,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

private struct AssociatedKeys {
    static var excludedViews = "excludedViews"
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                   shouldReceive touch: UITouch) -> Bool {

        guard let excludedViews = objc_getAssociatedObject(
            self,
            &AssociatedKeys.excludedViews
        ) as? [UIView] else {
            return true
        }

        for view in excludedViews {
            if touch.view?.isDescendant(of: view) == true {
                return false
            }
        }

        return true
    }
}

