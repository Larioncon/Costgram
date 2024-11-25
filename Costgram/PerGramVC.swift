//
//  PerGramVC.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 15.11.2024.
//

import UIKit

class PerGramVC: UIViewController {
    
    // UI элементы
       private let priceTextField = CGTextField(placeholder: "Price", rightContent: .symbol("dollarsign.square"))
       private let weightTextField = CGTextField(placeholder: "Weight", rightContent: .symbol("shippingbox"))
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
           title = "Price per gram"
           
           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
           
           // Настройка resultLabel
           resultLabel.translatesAutoresizingMaskIntoConstraints = false
           resultLabel.textColor = .white
           resultLabel.numberOfLines = 0
           resultLabel.textAlignment = .center
           resultLabel.font = UIFont.systemFont(ofSize: 18)
           resultLabel.text = "Result"
           
           // Добавляем элементы на экран
           view.addSubview(priceTextField)
           view.addSubview(weightTextField)
           view.addSubview(calculateButton)
           view.addSubview(resultLabel)
       }
       
       private func setupConstraints() {
           NSLayoutConstraint.activate([
               // Price TextField
               priceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
               priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               priceTextField.heightAnchor.constraint(equalToConstant: 56),
               
               // Weight TextField
               weightTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 20),
               weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               weightTextField.heightAnchor.constraint(equalToConstant: 56),
               
               // Calculate Button
               calculateButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
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
           calculateButton.addTarget(self, action: #selector(calculatePricePerGram), for: .touchUpInside)
       }
       
       @objc private func calculatePricePerGram() {
           guard
            let priceText = priceTextField.text?.replacingOccurrences(of: ",", with: "."),
               let weightText = weightTextField.text?.replacingOccurrences(of: ",", with: "."),
               let price = Double(priceText),
               let weight = Double(weightText),
               weight != 0
           else {
               resultLabel.text = "Invalid input"
               return
           }
           
           let pricePerGram = price / weight
           let pricePerKilo = pricePerGram * 1000
           
           resultLabel.text = String(format: "%.2f$ per gram\n%.2f$ per kilo", pricePerGram, pricePerKilo)
       }


}
