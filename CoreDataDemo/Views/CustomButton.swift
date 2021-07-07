//
//  CustomButton.swift
//  CoreDataDemo
//
//  Created by Екатерина Боровкова on 07.07.2021.
//

import Foundation
import UIKit
class CustomButton: UIButton {
    
    func createbutton() {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 4
    }
    
}
