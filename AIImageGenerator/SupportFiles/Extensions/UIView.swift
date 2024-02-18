//
//  UIView.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 18.02.2024.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
