/*
* Qulynym
* Extensions.swift
*
* Created by: Metah on 3/3/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit
import Alamofire

extension UIView {
    func setupShadow() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 5.0
    }
}

extension UIButton {
    func configureCloseBtnFrame(_ view: UIView) {
        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            topConstraint.constant = -12
        }
        
        NSLayoutConstraint.activate([
            topConstraint,
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
    
    func configureForwardBtnFrame(_ view: UIView) {
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
}


// MARK:- UILabel properties
extension UILabel {
    func setupMenuLabel(size: CGFloat) {
        self.textColor = .white
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        setupContentLabel(size: size)
    }
    
    func setupPlaylistLabel(size: CGFloat) {
        self.shadowColor = .black
        self.textColor = UIColor(red: 97/255, green: 104/255, blue: 189/255, alpha: 1)
        self.backgroundColor = .white
        setupContentLabel(size: size)
    }
    
    private func setupContentLabel(size: CGFloat) {
        self.textAlignment = .center
        self.font = UIFont(name: "Arial Rounded MT Bold", size: size)
        self.numberOfLines = 2
    }
}


// MARK:- UIImageView constraints
extension UIImageView {
    func configureBackgroundImagePosition(_ view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension UIColor {
    static let skyBlue = UIColor(red: 141/255, green: 232/255, blue: 237/255, alpha: 1)
    static let beigePink = UIColor(red: 0.99, green: 0.9, blue: 0.9, alpha: 1)
}
