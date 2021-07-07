//
//  NewTaskViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class NewTaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton()
        
        button.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        )
        
        button.setTitle("Save Task", for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: CustomButton = {
        let button = CustomButton()
        
        button.backgroundColor = UIColor(
            red: 240 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        )
        
        button.setTitle("Cancel Task", for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButtons()
        
        setupViews([taskTextField, saveButton, cancelButton])
        setConstraints()
    }
    
    private func setupButtons() {
        saveButton.createbutton()
        cancelButton.createbutton()
    }
    
    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        //        отключаем автопозиционирование констреинтов
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func save() {
        guard let text = taskTextField.text else { return }
        let _ = CoreDataManager.shared.save(text)
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
