//
//  CGTextField.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 18.11.2024.
//

import UIKit

class CGTextField: UITextField {
    
    
      // Свойство для отображения значка или текста справа
      private let rightContentView = UIView()
      private let rightLabel = UILabel()
      private let rightImageView = UIImageView()
      
      // Свойство для хранения изначального placeholder
      private var originalPlaceholder: String?
      
      // Тип для правого контента
      enum RightContent {
          case text(String)
          case symbol(String)
          case none
      }
      
      // Инициализация
      init(placeholder: String, rightContent: RightContent) {
          super.init(frame: .zero)
          self.originalPlaceholder = placeholder // Сохраняем изначальный placeholder
          self.placeholder = placeholder
          configure(rightContent: rightContent)
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          configure(rightContent: .none)
      }
      
      // Настройка внешнего вида и поведения
      private func configure(rightContent: RightContent) {
          translatesAutoresizingMaskIntoConstraints = false
          keyboardType = .decimalPad  // Только числовая клавиатура
          font = UIFont.systemFont(ofSize: 16)
          textColor = .customColorText
          backgroundColor = .customColorField
          layer.cornerRadius = 12
          layer.masksToBounds = true

          // Настройка отступов внутри текстового поля
          leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))  // Отступ слева
          leftViewMode = .always

          // Настройка правого контента
          setupRightContent(rightContent)

          // Placeholder: текст в центре
          textAlignment = .left
          attributedPlaceholder = NSAttributedString(
              string: originalPlaceholder ?? "",
              attributes: [NSAttributedString.Key.foregroundColor: UIColor.customColorText]
          )

          addTarget(self, action: #selector(editingBegan), for: .editingDidBegin)
          addTarget(self, action: #selector(editingEnded), for: .editingDidEnd)
      }
      
      // Установка контента справа
      private func setupRightContent(_ content: RightContent) {
          rightContentView.translatesAutoresizingMaskIntoConstraints = false
          addSubview(rightContentView)
          
          // Настройка правого контента
          rightContentView.addSubview(rightLabel)
          rightContentView.addSubview(rightImageView)
          
          rightLabel.translatesAutoresizingMaskIntoConstraints = false
          rightImageView.translatesAutoresizingMaskIntoConstraints = false
          
          // Конфигурация в зависимости от типа контента
          switch content {
          case .text(let text):
              rightLabel.text = text
              rightLabel.textColor = .customColorText
              rightLabel.font = UIFont.systemFont(ofSize: 20)
              rightLabel.isHidden = false
              rightImageView.isHidden = true
          case .symbol(let symbolName):
              rightImageView.image = UIImage(systemName: symbolName)
              rightImageView.tintColor = .customColorText
              rightImageView.contentMode = .scaleAspectFit
              rightLabel.isHidden = true
              rightImageView.isHidden = false
          case .none:
              rightLabel.isHidden = true
              rightImageView.isHidden = true
          }

          // Установка ограничений для правого контента
          NSLayoutConstraint.activate([
              rightContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
              rightContentView.centerYAnchor.constraint(equalTo: centerYAnchor),
              rightContentView.widthAnchor.constraint(equalToConstant: 40),
              rightContentView.heightAnchor.constraint(equalToConstant: 40),

              rightLabel.centerYAnchor.constraint(equalTo: rightContentView.centerYAnchor),
              rightLabel.centerXAnchor.constraint(equalTo: rightContentView.centerXAnchor),
              
              
              rightImageView.centerYAnchor.constraint(equalTo: rightContentView.centerYAnchor),
              rightImageView.trailingAnchor.constraint(equalTo: rightContentView.trailingAnchor, constant: -10),
              rightImageView.widthAnchor.constraint(equalToConstant: 30),
              rightImageView.heightAnchor.constraint(equalToConstant: 30)
          ])
          

      }
      
    
    // Убираем placeholder с анимацией
    @objc private func editingBegan() {
        guard let originalPlaceholder = originalPlaceholder else { return }
        
        UIView.transition(
            with: self,
            duration: 0.3, // Длительность анимации
            options: .transitionCrossDissolve,
            animations: {
                self.attributedPlaceholder = NSAttributedString(
                    string: "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear]
                )
            }
        )
    }

    // Восстанавливаем placeholder с анимацией, если поле пустое
    @objc private func editingEnded() {
        if text?.isEmpty ?? true {
            guard let originalPlaceholder = originalPlaceholder else { return }
            
            UIView.transition(
                with: self,
                duration: 0.3, // Длительность анимации
                options: .transitionCrossDissolve,
                animations: {
                    self.attributedPlaceholder = NSAttributedString(
                        string: originalPlaceholder,
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.customColorText]
                    )
                }
            )
        }
    }
  }
    
    

