//
//  MenuButton.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 15.11.2024.
//

import UIKit

class MenuButton: UIButton {

    
    // Инициализатор для передачи текста и VC
        init(title: String) {
            super.init(frame: .zero)
            setTitle(title, for: .normal)
            configure()
        }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        // Центрируем текст
        self.titleLabel?.textAlignment = .center
        // Размер текста
        self.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        // Цвет текста (помечен желтым, можно заменить)
        self.setTitleColor(.customColorText, for: .normal)
        // Фон кнопки (замените на нужный)
        self.backgroundColor = .customColorBtnMenu
                
        // Настроим Auto Layout ограничения для кнопки
        NSLayoutConstraint.activate([
        self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
   
}
