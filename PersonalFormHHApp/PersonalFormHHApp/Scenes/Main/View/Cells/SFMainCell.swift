//
//  SFMainCell.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

final class SFMainCell: BaseCollectionViewCell {
    
    let profileImage: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = R.Colors.secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let FIOLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = R.Colors.label
        label.font = R.Fonts.defaultFont(24, .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = R.Colors.secondaryLabel
        label.font = R.Fonts.defaultFont(14)
        label.numberOfLines = 1
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = R.Colors.secondaryLabel
        label.font = R.Fonts.defaultFont(14)
        label.numberOfLines = 1
        return label
    }()
    
    private let sloganAndCityStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 0
        return stack
    }()
    
    private let FIOAndSloganAndCityStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 4
        return stack
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 16
        return stack
    }()
    
    func setup(FIO: String, slogan: String, city: String) {
        changeCity(city)
        FIOLabel.text = FIO
        sloganLabel.text = slogan
        
        layoutIfNeeded()
    }
    
    func changeCity(_ city: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = R.Images.location
        
        let imageOffsetY: CGFloat = -3.0
        let imageOffsetX: CGFloat = -2.0
        imageAttachment.bounds = CGRect(x: imageOffsetX, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        
        let textAfterIcon = NSAttributedString(string: city)
        completeText.append(textAfterIcon)
        
        cityLabel.attributedText = completeText
        layoutIfNeeded()
    }
    
    func setImageProfile(_ image: UIImage) {
        profileImage.image = image
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.layer.masksToBounds = true
        
        layoutIfNeeded()
    }
}

extension SFMainCell {
    
    override func setupViews() {
        super.setupViews()
        
        sloganAndCityStack.addArrangedSubview(sloganLabel)
        sloganAndCityStack.addArrangedSubview(cityLabel)
        
        FIOAndSloganAndCityStack.addArrangedSubview(FIOLabel)
        FIOAndSloganAndCityStack.addArrangedSubview(sloganAndCityStack)
        
        mainStack.addArrangedSubview(profileImage)
        mainStack.addArrangedSubview(FIOAndSloganAndCityStack)
        
        setupView(mainStack)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = R.Colors.secondaryBackground
        backgroundView = lightView
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.layer.masksToBounds = true
    }
}
