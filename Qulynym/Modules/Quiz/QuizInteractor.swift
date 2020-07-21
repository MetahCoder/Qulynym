/*
 * Qulynym
 * QuizInteractor.swift
 *
 * Created by: Metah on 7/31/19
 *
 * Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol QuizInteractorProtocol: class {
    func saveData(slide count: Int, category name: String)
}

class QuizInteractor: QuizInteractorProtocol {
    weak var presenter: QuizPresenterProtocol!
    
    required init(_ presenter: QuizPresenterProtocol) {
        self.presenter = presenter
    }
}

extension QuizInteractor {
    func saveData(slide count: Int, category name: String) {
        UserDefaults.standard.set(count, forKey: name)
    }
}
