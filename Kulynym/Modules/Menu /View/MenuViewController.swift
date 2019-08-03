/*
* Kulynym
* MenuViewController.swift
*
* Created by: Metah on 6/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

enum Menu {
    case toddler
    case main
    case games
}

protocol MenuViewControllerProtocol: class {
    var menuType: Menu { get set }
    var sections: [String] { get set }
    var eduSections: [EduSection] { get set }
}

class MenuViewController: UIViewController, MenuViewControllerProtocol, MessageShowingVC {
    // MARK:- Properties
    var presenter: MenuPresenterProtocol!
    
    weak var playlistViewDelegate: PlaylistViewControllerProtocol!
    weak var secondMenuViewDelegate: MenuViewControllerProtocol!
    weak var scenesViewDelegate: ScenesViewControllerProtocol!
    
    var menuType: Menu = .main
    var sections = [String]()
    var eduSections = [EduSection]()
    
    var message: MessageManager!
    
    private weak var collectionView: UICollectionView!
    private weak var closeBtn: UIButton!
    
    private let configurator: MenuConfiguratorProtocol = MenuConfigurator()
    private var menuView: MenuViewProtocol!
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        initLayout()
        menuView.setupLayout()
        setupProperties()
        assignActions()
        initMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getSections()
        hideOrUnhideCloseBtn()
    }

    
    // MARK:- Layout
    private func initLayout() {
        menuView = MenuView(self.view)
    }
    
    private func setupProperties() {
        self.collectionView = menuView.collectionView
        self.closeBtn = menuView.closeBtn
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if menuType == .main {
            self.navigationController!.delegate = self
        }
        self.navigationController!.isNavigationBarHidden = true
    }
    
    private func hideOrUnhideCloseBtn() {
        closeBtn.isHidden = menuType == .main
    }
    
    
    // MARK:- Message
    func initMessage() {
        var emotion: Emotion?
        if menuType == .main {
            emotion = .hello
        }
        if menuType == .games {
            emotion = .games
        }
        guard let nonOptEmotion = emotion else { return }
        message = MessageManager(calling: self, showing: nonOptEmotion)
        message.showAlert()
    }
    
    
    // MARK:- Actions
    private func assignActions() {
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
    }
    
    @objc func closeBtnPressed() {
        presenter.closeView() 
    }
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuType == .toddler ? eduSections.count : sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        cell.imageName = menuType == .toddler ? eduSections[indexPath.row].name : sections[indexPath.row]
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5
        
        if menuType == .main {
            cell.layer.cornerRadius = 15
        } else {
            cell.layer.cornerRadius = view.frame.height * 0.25
        }
        cell.imageView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuType == .toddler {
            presenter.didSelectToddlerCell(at: indexPath.row)
        } else if menuType == .main {
            presenter.didSelectMenuCell(at: indexPath.row)
        } else {
            presenter.didSelectGamesCell(at: indexPath.row)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if menuType == .main  {
            return CGSize(width: view.frame.width * 0.5, height: view.frame.height * 0.5)
        }
        return CGSize(width: view.frame.height * 0.5, height: view.frame.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 84
    }
}


extension MenuViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}
