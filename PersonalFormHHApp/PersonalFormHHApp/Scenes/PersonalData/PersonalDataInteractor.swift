//
//  PersonalDataInteractor.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 03.08.2023
//

import Combine

protocol PersonalDataBuinessLogic: AnyObject {
    func toggleEditingState()
    func addSkill(_ skillName: String)
    func deleteSkill(at index: Int)
    func observeCity()
}

protocol PersonalDataDataSource {
    var isEditingSkills: Bool { get set }
    var skills: [SFSkill] { get set }
    var locationManager: SFLocationManager { get }
}

typealias PersonalDataInteractorProtocol = (PersonalDataBuinessLogic & PersonalDataDataSource)

class PersonalDataInteractor: PersonalDataInteractorProtocol {
    
    var presenter: PersonalDataPresenterProtocol?
    let locationManager = SFLocationManager.shared
    
    var isEditingSkills = false
    var skills = [SFSkill]()
    
    private var bag = Set<AnyCancellable>()
    
    func toggleEditingState() {
        isEditingSkills.toggle()
        presenter?.reloadData()
    }
    
    func addSkill(_ skillName: String) {
        let skill = SFSkill(name: skillName)
        skills.append(skill)
        presenter?.addSkillCell(at: skills.count - 1)
    }
    
    func deleteSkill(at index: Int) {
        skills.remove(at: index)
        presenter?.removeSkillCell(at: index)
    }
    
    func observeCity() {
        locationManager.requestLocation()
        locationManager.$city
            .sink { [weak self] city in
                self?.presenter?.updateCity(city)
            }
            .store(in: &bag)
    }
}
