/*
* Qulynym
* MenuRouter.swift
*
* Created by: Metah on 6/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

protocol MenuRouterProtocol: class {
    func showToddlerEdu()
    func showPlaylist(isKaraoke: Bool)
    func showDrawingView()
    func showItemView(content section: EduSection)
    func showGamesMenu()
    func openFlappyBird()
    func close()
    func showSettings()
}

class MenuRouter: MenuRouterProtocol {
    // MARK:- Properties
    weak var controller: MenuViewController!
    
    required init(_ controller: MenuViewController) {
        self.controller = controller
    }
}

extension MenuRouter {
    // MARK:- Protocol Methods
    func showToddlerEdu() {
        let vc = MenuViewController()
        controller.secondMenuViewDelegate = vc
        controller.secondMenuViewDelegate.menuType = .toddler
        showAnotherView(view: vc)
    }
    
    func showPlaylist(isKaraoke: Bool) {
        let vc = PlaylistViewController()
        controller.playlistViewDelegate = vc
        controller.playlistViewDelegate.isKaraoke = isKaraoke
        showAnotherView(view: vc)
    }
    
    func showDrawingView() {
        showAnotherView(view: DrawingViewController())
    }
   
    func showItemView(content section: EduSection) {
        let vc = ItemViewController()
        controller.itemViewDelegate = vc
        controller.itemViewDelegate.section = section
        showAnotherView(view: vc)
    }
    
    func showGamesMenu() {
        let vc = MenuViewController()
        controller.secondMenuViewDelegate = vc
        controller.secondMenuViewDelegate.menuType = .games
        showAnotherView(view: vc)
    }
    
    func openFlappyBird() {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        showAnotherView(view: GameViewController())
    }
    
    func close() {
        controller.navigationController!.popViewController(animated: true)
    }
    
    func showSettings() {
        showAnotherView(view: SettingsViewController())
    }
    
    private func showAnotherView(view toPresent: UIViewController) {
        controller.show(toPresent, sender: nil)
    }
}
