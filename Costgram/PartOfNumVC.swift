//
//  PartOfNumVC.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 22.11.2024.
//

import UIKit

class PartOfNumVC: UIViewController {
    // UI элементы
    private let firstNumTextField = CGTextField(placeholder: "Percent of number", rightContent: .text("%"))
       private let SecondNumTextField = CGTextField(placeholder: "Number", rightContent: .text("N"))
       private let calculateButton = CalcBtn(title: "Calculate")
       private let resultLabel = UILabel()
    
       override func viewDidLoad() {
           super.viewDidLoad()
           setupView()
           setupConstraints()
           setupActions()
           hideKeyboardWhenTappedAround()
       }
       
       private func setupView() {
           view.backgroundColor = .customColorDarkBlue
           title = "Part of Num"
           
           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
           
           // Настройка resultLabel
           resultLabel.translatesAutoresizingMaskIntoConstraints = false
           resultLabel.textColor = .white
           resultLabel.numberOfLines = 0
           resultLabel.textAlignment = .center
           resultLabel.font = UIFont.systemFont(ofSize: 18)
           resultLabel.text = "Result"
           
           // Добавляем элементы на экран
           view.addSubview(firstNumTextField)
           view.addSubview(SecondNumTextField)
           view.addSubview(calculateButton)
           view.addSubview(resultLabel)
       }
       
       private func setupConstraints() {
           NSLayoutConstraint.activate([
               // firstNumTextField
            firstNumTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            firstNumTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstNumTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstNumTextField.heightAnchor.constraint(equalToConstant: 56),
               
               // Weight TextField
            SecondNumTextField.topAnchor.constraint(equalTo: firstNumTextField.bottomAnchor, constant: 20),
            SecondNumTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            SecondNumTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            SecondNumTextField.heightAnchor.constraint(equalToConstant: 56),
               
               // Calculate Button
               calculateButton.topAnchor.constraint(equalTo: SecondNumTextField.bottomAnchor, constant: 20),
               calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               calculateButton.heightAnchor.constraint(equalToConstant: 56),
               
               // Result Label
               resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 30),
               resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
           ])
       }
       
       private func setupActions() {
           calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
       }
       
    @objc private func calculate() {
        guard
            let firstText = firstNumTextField.text?.replacingOccurrences(of: ",", with: "."),
            let secondText = SecondNumTextField.text?.replacingOccurrences(of: ",", with: "."),
            let percent = Double(firstText),
            let number = Double(secondText)
        else {
            resultLabel.text = "Invalid input"
            return
        }

        // Расчет процента от числа
        let result = (percent / 100) * number

        // Отображение результата
        resultLabel.text = String(format: "%.2f%% of %.2f is %.2f", percent, number, result)
    }


}
