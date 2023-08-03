//
//  PersonalDataRouter.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 03.08.2023
//

import UIKit

protocol PersonalDataRouterProtocol {
    func showAddSkillAlert(addSkill: @escaping (String) -> Void)
    func presentPhotoInputActionsheet()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    func dismiss()
}

class PersonalDataRouter: PersonalDataRouterProtocol {
    weak var viewController: PersonalDataViewController?
    
    func showAddSkillAlert(addSkill: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым вы владеете", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = ""
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let newSkill = alertController.textFields?.first?.text, !newSkill.isEmpty {
                addSkill(newSkill)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func presentPhotoInputActionsheet() {
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
        
        viewController?.present(actionSheet, animated: true)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.fixCannotMoveEditingBox()
        picker.sourceType = sourceType
        picker.delegate = viewController
        picker.allowsEditing = true
        viewController?.present(picker, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
