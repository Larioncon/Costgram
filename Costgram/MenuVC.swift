//
//  MenuVC.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 12.11.2024.
//

import UIKit

class MenuVC: UIViewController {
    let callPerGramVC = MenuButton(title: "Price per gram")
    let callPerncentVC = MenuButton(title: "Percentage Difference")
    let callPartOfNumVC = MenuButton(title: "Part of Num")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColorDarkBlue
        title = "Menu"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        configureCallPerGramVC()
        configureCallPercentVC()
        configureCallPartOfNumVC()
        hideKeyboardWhenTappedAround()
    }
    
    @objc func pushPerGramVC() {
            let perGramVC = PerGramVC()  // Ваш экран для "Price per gram"
            navigationController?.pushViewController(perGramVC, animated: true)
        }

    @objc func pushPercentVC() {
            let percentVC = PercentVC()  // Ваш экран для "Percentage Difference"
            navigationController?.pushViewController(percentVC, animated: true)
        }
    @objc func pushPartOfNumVC() {
            let partOfNumVC = PartOfNumVC()  // Ваш экран для "Percentage Difference"
            navigationController?.pushViewController(partOfNumVC, animated: true)
        }
    private func configureCallPerGramVC() {
        view.addSubview(callPerGramVC)
        callPerGramVC.addTarget(self, action: #selector(pushPerGramVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callPerGramVC.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            callPerGramVC.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callPerGramVC.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    private func configureCallPercentVC() {
        view.addSubview(callPerncentVC)
        callPerncentVC.addTarget(self, action: #selector(pushPercentVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callPerncentVC.topAnchor.constraint(equalTo: callPerGramVC.bottomAnchor, constant: 1),
            callPerncentVC.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callPerncentVC.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func configureCallPartOfNumVC() {
        view.addSubview(callPartOfNumVC)
        callPartOfNumVC.addTarget(self, action: #selector(pushPartOfNumVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callPartOfNumVC.topAnchor.constraint(equalTo: callPerncentVC.bottomAnchor, constant: 1),
            callPartOfNumVC.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callPartOfNumVC.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: Extension
extension UIColor {
    static let customColorDarkBlue = UIColor(hex: "#121A21")
    static let customColorBtnMenu = UIColor(hex: "#38526B")
    static let customColorText = UIColor(hex: "#94ADC7")
    static let customColorField = UIColor(hex: "#243647")
    static let customColorBtnCalc = UIColor(hex: "#1A80E5")
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
