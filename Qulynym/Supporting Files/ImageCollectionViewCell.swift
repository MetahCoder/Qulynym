/*
* Qulynym
* ImageCollectionViewCell.swift
*
* Created by: Metah on 6/11/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK:- Properties
    var imageName: String! {
        didSet {
            imageView.image = UIImage(named: imageName)
        }
    }
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var text: String! {
        didSet {
            sectionTitleLabel.text = text
        }
    }
    var textSize: CGFloat! {
        didSet {
            sectionTitleLabel.setupContentLabel(size: textSize)
        }
    }
    var imageViewCornerRadius: CGFloat! {
        didSet {
            imageView.layer.cornerRadius = imageViewCornerRadius
        }
    }
    var imageViewContentMode: ContentMode! {
        didSet {
            imageView.contentMode = imageViewContentMode
        }
    }
    var imageViewOpacity: Float! {
        didSet {
            imageView.layer.opacity = imageViewOpacity
        }
    }
    var imageViewLayerMasksToBounds: Bool! {
        didSet {
            imageView.layer.masksToBounds = imageViewLayerMasksToBounds
        }
    }
    var titleLabelBackgroundColor: UIColor? {
        didSet {
            sectionTitleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var sectionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.layer.cornerRadius = 15
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    // MARK:- Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(sectionTitleLabel)
        setAutoresizingMaskToFalse()
        activateConstraints()
    }
    
    
    // MARK:- Layout
    private func setAutoresizingMaskToFalse() {
        _ = self.subviews.map{ $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 16),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.sectionTitleLabel.text = ""
        self.imageView.image = nil
    }
}
