//
//  CalcBtn.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 16.11.2024.
//

import UIKit

class CalcBtn: UIButton {

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
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .customColorBtnCalc
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 100)
            ])

        guard let superview = superview else {
                return
            }
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 18),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -18)
            ])
    }
    
}
