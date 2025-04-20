//
//  ViewController.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/20/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var currencyRates: [CurrencyRate] = []
    private let apiService = APIService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        fetchCurrentRateData()

    }


    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()

    private func fetchCurrentRateData() {
        let urlComponents = URLComponents(string: "https://open.er-api.com/v6/latest/USD")
        //        urlComponents?.queryItems = self.queryItems

        print(#fileID, #function, #line, "print urlComponents?.url: \(String(describing: urlComponents?.url))")
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }

        apiService.fetchData(url: url) { [weak self] (result: ModelData?) in
            guard let self else { return }

            
            guard let result else {
                   DispatchQueue.main.async {
                       self.showAlert(title: "오류", message: "데이터를 불러올 수 없습니다.")
                   }
                   return
               }

            let mappingData = result.rates.map{ (key, value) in
                CurrencyRate(countryCode: key, rate: value)}
            self.currencyRates = mappingData.sorted(by: {$0.countryCode < $1.countryCode})
            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }

        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

        let item = currencyRates[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}


