//
//  PerGramVC.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 15.11.2024.
//

import UIKit
import CoreData

class PerGramVC: UIViewController {
    
    // UI элементы
    private let priceTextField = CGTextField(placeholder: "Price", rightContent: .symbol("dollarsign.square"))
    private let weightTextField = CGTextField(placeholder: "Weight", rightContent: .symbol("shippingbox"))
    private let calculateButton = CalcBtn(title: "Calculate")
    private let resultsTableView = ResultTableView()
    private let clearBtn: UIButton = {
        let button = UIButton(type: .system) // Тип .system — стандартный для кнопки
        button.setTitle("Clear", for: .normal) // Текст на кнопке
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Размер шрифта
        button.setTitleColor(.customColorText, for: .normal) // Цвет текста
        button.setTitleColor(.lightGray, for: .highlighted) // Цвет текста при нажатии
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        hideKeyboardWhenTappedAround()
        
        // Загрузить сохранённые результаты
        loadResults()
    }
    
    private func setupView() {
        view.backgroundColor = .customColorDarkBlue
        title = "Price per gram"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Добавляем элементы на экран
        view.addSubview(priceTextField)
        view.addSubview(weightTextField)
        view.addSubview(calculateButton)
        view.addSubview(clearBtn)
        view.addSubview(resultsTableView)
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
            
            // Clear Button
            clearBtn.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            clearBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Results Table View
            resultsTableView.topAnchor.constraint(equalTo: clearBtn.bottomAnchor, constant: 30),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        calculateButton.addTarget(self, action: #selector(calculatePricePerGram), for: .touchUpInside)
        clearBtn.addTarget(self, action: #selector(clearResults), for: .touchUpInside)
    }
    
    @objc private func clearResults() {
        // Очистка таблицы и Core Data
        resultsTableView.clearResults()
        clearCoreData()
    }
    
    @objc private func calculatePricePerGram() {
        guard
            let priceText = priceTextField.text?.replacingOccurrences(of: ",", with: "."),
            let weightText = weightTextField.text?.replacingOccurrences(of: ",", with: "."),
            let price = Double(priceText),
            let weight = Double(weightText),
            weight != 0
        else {
            addResult("Invalid input")
            return
        }
        
        let pricePerGram = price / weight
        let pricePerKilo = pricePerGram * 1000
        let resultText = String(format: "%.2f$ per gram\n%.2f$ per kilo", pricePerGram, pricePerKilo)
        
        // Сохранить результат в Core Data
        saveResult(resultText)
        
        addResult(resultText)
    }
    
    private func addResult(_ text: String) {
        resultsTableView.addResult(text)
    }
    
    // MARK: - Core Data Methods
    
    private func saveResult(_ result: String) {
        let newResult = CalculationResults(context: context)
        newResult.createdAt = Date()
        newResult.resultGram = result
        
        do {
            try context.save()
        } catch {
            print("Failed to save result: \(error)")
        }
    }
    
    private func loadResults() {
        let request: NSFetchRequest<CalculationResults> = CalculationResults.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do {
            let results = try context.fetch(request)
            for result in results {
                if let resultGram = result.resultGram {
                    addResult(resultGram)
                }
            }
        } catch {
            print("Failed to fetch results: \(error)")
        }
    }
    
    private func clearCoreData() {
        // Создаем запрос для получения всех объектов, где resultPercent не nil
        let request: NSFetchRequest<CalculationResults> = CalculationResults.fetchRequest()
        request.predicate = NSPredicate(format: "resultGram != nil") // Фильтруем только записи с результатом

        do {
            // Загружаем все объекты, которые соответствуют предикату
            let results = try context.fetch(request)
            
            // Для каждой записи с результатом
            for result in results {
                if let resultGram = result.resultGram {
                    // Если результат существует, удаляем запись
                    context.delete(result)
                }
            }
            
            // Сохраняем изменения
            try context.save()
        } catch {
            print("Failed to clear resultPercent from Core Data: \(error)")
        }
    }
}
