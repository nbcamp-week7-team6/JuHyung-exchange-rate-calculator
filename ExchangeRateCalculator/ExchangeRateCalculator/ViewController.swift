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
    private let searchBar = UISearchBar()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
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
                let countryName: String
                if let name = CountryMapping[key] {
                    countryName = name
                } else {
                    print("일치하는 도시 코드 없음")
                    countryName = "일치하는 도시 코드 없음"
                }
                return CurrencyRate(currencyCode: key, country: countryName, rate: value)
            }
            self.currencyRates = mappingData.sorted(by: {$0.currencyCode < $1.currencyCode})

            //  MARK: -- 문제 발견 guard let 을 쓰니 map과정에서 return nil 발생
//            let mappingData = result.rates.map{ (key, value) in
//                guard let countryName = CountryMapping[key] else {
//                    return
//                }
//                CurrencyRate(currencyCode: key, country: countryName, rate: value)}
//            self.currencyRates = mappingData.sorted(by: {$0.currencyCode < $1.currencyCode})
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

    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(searchBar)

        tableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
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
        cell.configure(currencyCode: item.currencyCode, rate: item.rate)
        return cell
    }
}


