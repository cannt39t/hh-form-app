//
//  Resources.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

enum R {
    
    enum Colors {
        static let background = UIColor(named: "background")
        static let secondaryBackground = UIColor(named: "secondaryBackground")
        
        static let label = UIColor(named: "label")
        static let secondaryLabel = UIColor(named: "secondaryLabel")
    }
    
    enum Images {
        static let cancel = UIImage(named: "cancel")
        static let checkmarkCircle = UIImage(named: "checkmarkCircle")
        static let location = UIImage(named: "location")
        static let pencil = UIImage(named: "pencil")
        
        static let mock = UIImage(named: "Ivan")
    }
    
    enum Fonts {
        static func defaultFont(_ size: CGFloat, _ weight: UIFont.Weight = .regular) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    enum Strings {
        enum Headers {
            static func getHeaderForMainController(section: PersonalDataViewController.Sections) -> String {
                switch section {
                    case .skills: return "Мои навыки"
                    case .about: return "О себе"
                    default: return ""
                }
            }
        }
        
        enum Titles {
            static let profile = "Профиль"
        }
        
        enum Mock {
            static let FIO = "Казначеев Илья Андреевич"
            static let slogan = "Junior iOS-разработчик, опыт более 1 года"
            static let about = "As an enthusiastic and ambitious student with extensive experience in computer science, I am eager to continue developing my skills in iOS development and secure a promising job."
        }
    }
}
