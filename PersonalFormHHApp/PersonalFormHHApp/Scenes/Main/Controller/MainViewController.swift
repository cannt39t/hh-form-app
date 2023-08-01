//
//  MainViewController.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit
import Combine

final class MainViewController: BaseCollectionViewController {
    
    private var skills = [SFSkill]()
    private var isEditingSkills = false
    
    private var bag = Set<AnyCancellable>()
    private let locationManager = SFLocationManager.shared
    
    private weak var mainCell: SFMainCell? = nil
    
    enum Sections: Int, CaseIterable {
        case main, skills, about
    }
    
    init() {
        let layout = MainViewController.createCompositionalLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        
        switch section {
            case .main: return 1
            case .skills:
                return isEditingSkills ? skills.count + 1 : skills.count
            case .about: return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
            case .main:
                let cell = collectionView.getReuseCell(SFMainCell.self, indexPath: indexPath)
                cell.setup(
                    FIO: R.Strings.Mock.FIO,
                    slogan: R.Strings.Mock.slogan,
                    city: locationManager.city
                )
                self.mainCell = cell
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage(_:)))
                cell.profileImage.addGestureRecognizer(tap)
                return cell
            case .skills:
                let cell = collectionView.getReuseCell(SFSkillCell.self, indexPath: indexPath)
                if indexPath.item == skills.count {
                    cell.setup(skill: "+", isEditing: false) { }
                } else {
                    let skill = skills[indexPath.item]
                    cell.setup(skill: skill.name, isEditing: isEditingSkills) { [weak self] in
                        self?.deleteSkill(indexPath.item)
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
                headerView.setup(title: title, buttonHidden: false, isEditing: isEditingSkills) { [weak self] in
                    self?.didTapOnEditingButton()
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
        let addindexPath = IndexPath(item: skills.count, section: Sections.skills.rawValue)
        if indexPath == addindexPath {
            showAddSkillAlert()
        }
    }
}

extension MainViewController {
    
    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (index, enviroment) -> NSCollectionLayoutSection? in
            return MainViewController.createSectionFor(index: index, enviroment: enviroment)
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
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
        section.contentInsets = .init(top: 0, leading: 16, bottom: 24, trailing: 16)
        section.interGroupSpacing = 8
        
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

extension MainViewController {
    
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
        
        locationManager.requestLocation()
        observeCity()
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


extension MainViewController {
    
    private func didTapOnEditingButton() {
        isEditingSkills.toggle()
        collectionView.reloadData()
    }
    
    private func showAddSkillAlert() {
        let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым вы владеете", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = ""
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            if let newSkill = alertController.textFields?.first?.text, !newSkill.isEmpty {
                self?.addSkill(newSkill)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addSkill(_ skillName: String) {
        let insertionIndex = skills.count
        let skill = SFSkill(name: skillName)
        skills.append(skill)
        
        let indexPath = IndexPath(item: insertionIndex, section: Sections.skills.rawValue)
        collectionView.insertItems(at: [indexPath])
    }
    
    private func deleteSkill(_ item: Int) {
        skills.remove(at: item)
        
        let indexPath = IndexPath(item: item, section: Sections.skills.rawValue)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension MainViewController {
    
    @objc private func tapOnImage(_ sender: UITapGestureRecognizer) {
        presentPhotoInputActionsheet()
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Изменить изображение профиля", message: "Откуда вы хотите выбрать изображение?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .camera)
        }
        let galleryAction = UIAlertAction(title: "Галерея", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.fixCannotMoveEditingBox()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        dismiss(animated: true)
    }
}
 
extension MainViewController {
    
    private func observeCity() {
        locationManager.$city
            .sink { [weak self] city in
                self?.mainCell?.changeCity(city)
            }
            .store(in: &bag)
    }
}
