//
//  PercentVC.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 15.11.2024.
//  Percentage Difference

import UIKit
import CoreData


class PercentVC: UIViewController {
    // UI элементы
       private let firstNumTextField = CGTextField(placeholder: "Larger number", rightContent: .text("1"))
       private let SecondNumTextField = CGTextField(placeholder: "Smaller number", rightContent: .text("2"))
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
           title = "Percentage Difference"
           
           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
           
           
           // Добавляем элементы на экран
           view.addSubview(firstNumTextField)
           view.addSubview(SecondNumTextField)
           view.addSubview(calculateButton)
           view.addSubview(clearBtn)
           view.addSubview(resultsTableView)
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
           calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
           clearBtn.addTarget(self, action: #selector(clearResults), for: .touchUpInside)
       }
    
    
       @objc private func clearResults() {
        // Очистка таблицы и Core Data
        resultsTableView.clearResults()
        clearCoreData()
     }
    
    
       @objc private func calculate() {
           guard
            let firstText = firstNumTextField.text?.replacingOccurrences(of: ",", with: "."),
               let secondText = SecondNumTextField.text?.replacingOccurrences(of: ",", with: "."),
               let firstNum = Double(firstText),
               let secondNum = Double(secondText),
               secondNum != 0
           else {
               addResult("Invalid input")
               return
           }
           
           let differencePercentage = ((firstNum - secondNum) / secondNum) * 100
           
           
           let resultText = String(format: "The difference between %.2f and %.2f is: %.2f%%", firstNum, secondNum, differencePercentage)
           
           
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
        newResult.resultPercent = result
        
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
                if let resultPercent = result.resultPercent {
                    addResult(resultPercent)
                }
            }
        } catch {
            print("Failed to fetch results: \(error)")
        }
    }
    
    private func clearCoreData() {
        // Создаем запрос для получения всех объектов, где resultPercent не nil
        let request: NSFetchRequest<CalculationResults> = CalculationResults.fetchRequest()
        request.predicate = NSPredicate(format: "resultPercent != nil") // Фильтруем только записи с результатом

        do {
            // Загружаем все объекты, которые соответствуют предикату
            let results = try context.fetch(request)
            
            // Для каждой записи с результатом
            for result in results {
                if let resultPercent = result.resultPercent {
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
