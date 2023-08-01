//
//  SFBiggerButton.swift
//  PersonalFormHHApp
//
//  Created by Илья Казначеев on 01.08.2023.
//

import UIKit

final class SFBiggerButton: BaseButton {
    
    private let increasePX: CGFloat
    
    init(increasePX: CGFloat) {
        self.increasePX = increasePX
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -increasePX, dy: -increasePX).contains(point)
    }
}
