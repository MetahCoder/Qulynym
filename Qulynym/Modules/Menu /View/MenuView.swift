/*
* Qulynym
* MenuView.swift
*
* Created by: Metah on 6/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

protocol MenuViewProtocol: class {
    var collectionView: UICollectionView { get }
    var closeBtn: UIButton { get }
    var settingsBtn: UIButton { get }
    
    func setupLayout()
}

class MenuView: MenuViewProtocol {
    // MARK:- Properties
    lazy var collectionView: UICollectionView = {
        return configureImagesCollectionView(scroll: .horizontal, image: "menu", background: nil)
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        return btn
    }()
    lazy var settingsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "settings"), for: .normal)
        return btn
    }()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Qulynym"
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: view.frame.height * 0.1)
        lbl.textColor = UIColor(red: 97/255, green: 104/255, blue: 189/255, alpha: 1)
        lbl.shadowColor = .black
        return lbl
    }()
    private weak var view: UIView!
    
    
    // MARK:- Initialization
    required init(_ view: UIView) {
        self.view = view
    }
    
    
    // MARK:- Layout
    func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(settingsBtn)
        view.addSubview(titleLabel)
        setAutoresizingFalse()
        activateConstraints()
        closeBtn.configureCloseBtnFrame(view)
    }
    
    private func setAutoresizingFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let constant = view.frame.width * 0.01
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            settingsBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            settingsBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            settingsBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.06),
            settingsBtn.widthAnchor.constraint(equalTo: settingsBtn.heightAnchor)
        ])
    }
}
