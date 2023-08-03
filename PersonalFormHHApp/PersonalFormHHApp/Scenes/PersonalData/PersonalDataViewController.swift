//
//  PersonalDataViewController.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 03.08.2023
//

import UIKit

protocol PersonalDataViewProtocol: AnyObject {
    func reloadCollection()
    func addSkillCell(at index: Int)
    func removeSkillCell(at index: Int)
    func updateCity(_ city: String)
}

final class PersonalDataViewController: BaseCollectionViewController {
    var interactor: PersonalDataInteractorProtocol
    var router: PersonalDataRouterProtocol
    
    init(interactor: PersonalDataInteractorProtocol, router: PersonalDataRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        super.init(collectionViewLayout: PersonalDataViewController.createCompositionalLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private weak var mainCell: SFMainCell? = nil
    
    enum Sections: Int, CaseIterable {
        case main, skills, about
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        
        switch section {
            case .main: return 1
            case .skills:
                return interactor.isEditingSkills ? interactor.skills.count + 1 : interactor.skills.count
            case .about: return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UICollectionViewCell() }

        switch section {
            case .main:
                let cell = collectionView.getReuseCell(SFMainCell.self, indexPath: indexPath)
                cell.setup(data: SFPersonalData(
                    FIO: R.Strings.Mock.FIO,
                    slogan: R.Strings.Mock.slogan,
                    city: interactor.locationManager.city)
                )
                self.mainCell = cell
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileImage))
                cell.profileImage.addGestureRecognizer(tap)
                return cell
            case .skills:
                let cell = collectionView.getReuseCell(SFSkillCell.self, indexPath: indexPath)
                if indexPath.item == interactor.skills.count {
                    cell.setup(text: "+", isEditing: false) { }
                } else {
                    let skill = interactor.skills[indexPath.item]
                    cell.setup(text: skill.name, isEditing: interactor.isEditingSkills) { [weak self] in
                        self?.interactor.deleteSkill(at: indexPath.item)
                    }
                }
                return cell
            case .about:
                let cell = collectionView.getReuseCell(SFAboutCell.self, indexPath: indexPath)
                cell.setup(with: R.Strings.Mock.about)
                return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = Sections(rawValue: indexPath.section) else { return UICollectionReusableView() }

        let title = R.Strings.Headers.getHeaderForMainController(section: section)
        switch section {
            case .skills:
                let headerView = collectionView.getReuseSupplementaryView(SFHeader.self, indexPath: indexPath)
                headerView.setup(title: title, buttonHidden: false, isEditing: interactor.isEditingSkills) { [weak self] in
                    self?.interactor.toggleEditingState()
                }
                return headerView
            case .about:
                let headerView = collectionView.getReuseSupplementaryView(SFHeader.self, indexPath: indexPath)
                headerView.setup(title: title, buttonHidden: true, isEditing: false)
                return headerView
            default:
                return UICollectionReusableView()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let addindexPath = IndexPath(item: interactor.skills.count, section: Sections.skills.rawValue)
        if indexPath == addindexPath {
            router.showAddSkillAlert { [weak self] skillName in
                self?.interactor.addSkill(skillName)
            }
        }
    }
}

@objc extension PersonalDataViewController {
    
    private func didTapOnProfileImage() {
        router.presentPhotoInputActionsheet()
    }
}

extension PersonalDataViewController {
    
    override func configureAppearance() {
        super.configureAppearance()
        
        title = R.Strings.Titles.profile
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SFHeader.self)
        collectionView.register(SFAboutCell.self)
        collectionView.register(SFMainCell.self)
        collectionView.register(SFSkillCell.self)
        
        collectionView.backgroundColor = R.Colors.background
        view.backgroundColor = R.Colors.background
        
        interactor.observeCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = R.Colors.secondaryBackground
        appearance.titleTextAttributes = [.foregroundColor: R.Colors.label!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension PersonalDataViewController: PersonalDataViewProtocol {
    
    func reloadCollection() {
        collectionView.reloadData()
    }
    
    func addSkillCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: Sections.skills.rawValue)
        collectionView.insertItems(at: [indexPath])
    }
    
    func removeSkillCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: Sections.skills.rawValue)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    func updateCity(_ city: String) {
        mainCell?.changeCity(city)
    }
}

extension PersonalDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            let indexPath = IndexPath(row: 0, section: 0)
            let profileCell = collectionView.cellForItem(at: indexPath) as! SFMainCell
            if let image = pickedImage.fixedOrientation() {
                profileCell.setImageProfile(image)
            } else {
                profileCell.setImageProfile(pickedImage)
            }
        }
        router.dismiss()
    }
}

extension PersonalDataViewController {
    
    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (index, enviroment) -> NSCollectionLayoutSection? in
            return PersonalDataViewController.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private static func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        guard let section = Sections(rawValue: index) else { fatalError() }
        switch section {
            case .main: return personalDataSection()
            case .skills: return skillsSection()
            case .about: return aboutSection()
        }
    }
    
    private static func personalDataSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private static func skillsSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(46)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 12
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SFHeader.identifier, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private static func aboutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(30))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SFHeader.identifier, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
