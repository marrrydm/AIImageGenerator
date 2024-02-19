//
//  GradientViews.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 15.02.2024.
//

import UIKit

class GradientView: UIView {
    private lazy var gradientLayer: CAGradientLayer = {
        let view = CAGradientLayer()
        view.frame = self.bounds
        view.colors = [
            UIColor(red: 0.216, green: 0.008, blue: 0.345, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        view.startPoint = CGPoint(x: 0.0, y: 0.0)
        view.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.locations = [0.0, 0.2]
        layer.insertSublayer(view, at: 0)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
