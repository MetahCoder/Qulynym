 /*
* Qulynym
* DrawingsCollectionView.swift
*
* Created by: Metah on 8/5/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
 */

import UIKit

class DrawingsCollectionView: UIViewController {
    // MARK:- Properties
    var pictures = ["whiteCanvas", "flowerDrawing", "penguinDrawing", "catterpilarDrawing", "butterflyDrawing"]
    weak var drawingView: DrawingViewControllerProtocol!
    private lazy var mainCollectionView: UICollectionView = {
        return configureImagesCollectionView(scroll: .vertical, image: nil, background: .white)
    }()
    private lazy var invisibleButtonToExit: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        view.addSubview(mainCollectionView)
        view.addSubview(invisibleButtonToExit)
        setupCollectionView()
        setupAppearence()
        activateConstraints()
        invisibleButtonToExit.addTarget(self, action: #selector(exitFromMenu), for: .touchUpOutside)
    }
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupAppearence() {
        view.layer.zPosition = 1
        view.backgroundColor = .white
        
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            invisibleButtonToExit.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invisibleButtonToExit.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invisibleButtonToExit.topAnchor.constraint(equalTo: view.topAnchor),
            invisibleButtonToExit.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    // MARK:- Methods
    @objc
    private func exitFromMenu() {
        #warning("still not working")
        drawingView.closeMenu()
    }
}

extension DrawingsCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK:- UICollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        if indexPath.row == 0 {
            cell.imageName = "noDrawing"
        } else {
            cell.imageName = pictures[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            drawingView.currentImageName = nil
        }
        drawingView.currentImageName = pictures[indexPath.row]
        drawingView.closeMenu()
        drawingView.clearCanvas()
    }
}

