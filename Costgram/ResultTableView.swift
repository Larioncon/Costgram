import UIKit

class ResultTableView: UITableView {
    
    private var results: [String] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
    }
    
    func addResult(_ result: String) {
        results.insert(result, at: 0) // Добавляем новый результат в начало
        self.reloadData()
    }
}

extension ResultTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        
        // Используем UIListContentConfiguration
        var content = UIListContentConfiguration.cell()
        content.text = results[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.systemFont(ofSize: 24)
        content.textProperties.numberOfLines = 0
        content.textProperties.alignment = .center
        
        // Применяем конфигурацию
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}

extension ResultTableView {
    func clearResults() {
        results.removeAll()  // Очищаем массив результатов
        self.reloadData()     // Перезагружаем таблицу
    }
}
