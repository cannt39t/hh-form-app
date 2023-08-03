//
//  PersonalDataPresenter.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 03.08.2023
//

protocol PersonalDataPresenterProtocol: AnyObject {
    func reloadData()
    func addSkillCell(at index: Int)
    func removeSkillCell(at index: Int)
    func updateCity(_ city: String)
}

final class PersonalDataPresenter {
    var view: PersonalDataViewProtocol?
}

extension PersonalDataPresenter: PersonalDataPresenterProtocol {
    
    func reloadData() {
        view?.reloadCollection()
    }
    
    func addSkillCell(at index: Int) {
        view?.addSkillCell(at: index)
    }
    
    func removeSkillCell(at index: Int) {
        view?.removeSkillCell(at: index)
    }
    
    func updateCity(_ city: String) {
        view?.updateCity(city)
    }
}
