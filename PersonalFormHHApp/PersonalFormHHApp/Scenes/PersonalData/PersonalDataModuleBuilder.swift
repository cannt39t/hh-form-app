//
//  PersonalDataModuleBuilder.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 03.08.2023
//

import UIKit

class PersonalDataModuleBuilder {
    static func build() -> PersonalDataViewController {
        let interactor = PersonalDataInteractor()
        let router = PersonalDataRouter()
        let presenter = PersonalDataPresenter()
        
        interactor.presenter = presenter
        
        let viewController = PersonalDataViewController(interactor: interactor, router: router)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}
