/*
* Kulynym
* QuizRouter.swift
*
* Created by: Metah on 7/31/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol QuizRouterProtocol: class {
    func backToItem(didPass: Bool)
    func close()
}

class QuizRouter: QuizRouterProtocol {
    weak var view: QuizViewController!
    
    required init(_ view: QuizViewController) {
        self.view = view
    }
}

extension QuizRouter {
    func backToItem(didPass: Bool) {
        if !didPass {
            view.itemView.slideCount -= 4
        }
        view.dismiss(animated: true, completion: nil)
    }
    
    func close() {
        view.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
