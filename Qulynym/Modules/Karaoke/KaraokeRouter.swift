/*
* Kulynym
* KaraokeRouter.swift
*
* Created by: Metah on 5/30/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol KaraokeRouterProtocol: class {
    func close()
}

class KaraokeRouter: KaraokeRouterProtocol {
    // MARK:- Properties
    weak var controller: KaraokeViewController!
    
    required init(_ controller: KaraokeViewController) {
        self.controller = controller
    }
}

extension KaraokeRouter {
    func close() {
        AudioPlayer.karaokeAudioPlayer.stop()
        controller.navigationController?.popViewController(animated: true)
        if AudioPlayer.backgroundAudioStatePlaying {
            AudioPlayer.backgroundAudioPlayer.play()
        }
    }
}
