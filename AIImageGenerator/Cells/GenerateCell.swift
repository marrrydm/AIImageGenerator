//
//  CustomCollectionViewCell.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 15.02.2024.
//

import UIKit
import SnapKit

class GenerateCell: UICollectionViewCell {
    // MARK: - Constants
    private let imageViewHeightMultiplier: CGFloat = 0.5
    private let contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    // MARK: - Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true

        return view
    }()

    private let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .white
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont(name: "Skia", size: 18)

        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    // MARK: - Public Methods
    func configure(withImage image: String, labelText: String) {
        imageView.image = UIImage(named: image)
        label.text = labelText
    }
}
