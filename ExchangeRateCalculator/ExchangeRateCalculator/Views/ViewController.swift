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
    private let viewModel = ViewModel()

    //VM에서 변경된 상태를 사용
    private var allRates: [CurrencyRate] = []
    private var filteredRates: [CurrencyRate] = []
    private var baseCurrency: CurrencyRate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 정보"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()


    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "통화 검색"
        searchBar.showsCancelButton = false
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

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        modelSubscriber()
        viewModel.action?(.fetch)
    }

    func modelSubscriber(){
        viewModel.stateChanged = {[weak self] state in

            DispatchQueue.main.async{
                if let alertMessage = state.errorMessage, alertMessage.isEmpty  {
                    //Chain the optional using '?' to access member 'showAlert' only for non-'nil' base values
                    self?.showAlert(title: "오류", message: alertMessage)
                    return
                }
                self?.filteredRates = state.filteredRates
                self?.tableView.backgroundView = state.filteredRates.isEmpty ? self?.noText : nil
                self?.tableView.reloadData()
            }
        }


    }
    //    func setData(_ data: [CurrencyRate]) {
    //        viewModel.setRates(data)
    //        tableView.reloadData()
    //    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    private func configureUI() {

        //titleLabel 보류

        [searchBar,tableView]
            .forEach{view.addSubview($0)}

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrail = viewModel.filteredRates[indexPath.row]

        guard let baseCurrency = viewModel.baseCurrency else {
            print("기준 통화 없음")
            return
        }

        let detailVM = DetailViewModel(targetCurrency: selectedTrail, baseCurrency: baseCurrency)
        let detailVC = DetailViewController(viewModel: detailVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        currencyRates.count
        return filteredRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.filteredRates[indexPath.row]
        cell.configure(currencyCode: item.currencyCode, rate: item.rate)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.filter(text: searchText))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


