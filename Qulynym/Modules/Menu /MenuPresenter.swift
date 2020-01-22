/*
* Qulynym
* MenuPresenter.swift
*
* Created by: Metah on 6/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol MenuPresenterProtocol: class {
    func getSections()
    func didSelectMenuCell(at index: Int)
    func didSelectPlaylistCell(at index: Int)
    func didSelectVideoCell(at index: Int)
    func didSelectToddlerCell(at index: Int)
    func didSelectGamesCell(at index: Int)
    func closeView()
    func goToSettings()
}

class MenuPresenter: MenuPresenterProtocol {
    // MARK:- Properties
    weak var controller: MenuViewControllerProtocol!
    var interactor: MenuInteractor!
    var router: MenuRouterProtocol!
    
    required init(_ controller: MenuViewControllerProtocol) {
        self.controller = controller
    }
}

extension MenuPresenter {
    // MARK:- Protocol Methods
    func getSections() {
        #warning("beineler data passing")
        if controller.menuType == .toddler {
            controller.eduSections = interactor.getEduSections()
        } else {
            controller.sections = interactor.getStringSections(controller.menuType)
        }
    }
    
    func didSelectMenuCell(at index: Int) {
        switch index {
        case 0: router.showBeinelerPlaylists()
        case 1: router.showToddlerEdu()
        case 4: router.showDrawingView()
        case 5: router.showGamesMenu()
        default: router.showPlaylist(isKaraoke: (index == 2))
        }
    }
    
    func didSelectPlaylistCell(at index: Int) {
        router.showBeineler()
    }
    
    func didSelectVideoCell(at index: Int) {
        #warning("data passing")
        router.showVideoView(video: "Oet7BDrTfhM")
    }
    
    func didSelectToddlerCell(at index: Int) {
        router.showItemView(content: controller.eduSections[index])
    }
    
    func didSelectGamesCell(at index: Int) {
        switch index {
        case 0:
            router.openFlappyBird()
        default:
            return
        }
    }
    
    func closeView() {
        router.close()
    }
    
    func goToSettings() {
        router.showSettings()
    }
}
