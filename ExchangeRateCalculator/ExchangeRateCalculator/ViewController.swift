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
    private let viewModel = ViewModel()


    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "통화 검색"
        searchBar.showsCancelButton = true
        return searchBar
    }()

    //아 이거 변수명 어렵다
    private let noText: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchCurrentRateData()

    }


    func setData(_ data: [CurrencyRate]) {
        viewModel.setRates(data)
        tableView.reloadData()
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
                self.setData(self.currencyRates)
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

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
//        currencyRates.count
            let count = viewModel.filteredRates.count
            tableView.backgroundView = (count == 0) ? noText : nil
            return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

//        let item = currencyRates[indexPath.row]
        let item = viewModel.filteredRates[indexPath.row]
        cell.configure(currencyCode: item.currencyCode, rate: item.rate)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterRates(with: searchText)
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterRates(with: searchBar.text ?? "")
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.restoreRates()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}


