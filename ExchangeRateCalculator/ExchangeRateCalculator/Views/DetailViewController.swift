//
//  ViewDetail.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/21/25.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {

    private let detailViewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.detailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)

    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 정보"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = detailViewModel.currencyCode
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = detailViewModel.countryName
        return label
    }()


    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.placeholder = "금액을 입력하세요"
        return textField
    }()


    private let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("환율 계산", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()


    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "계산 결과가 여기에 표시됩니다"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    @objc func convertButtonTapped() {
        guard let text = amountTextField.text, !text.isEmpty else {
            showAlert(title: "오류", message: "금액을 입력해주세요")
            return
        }
        guard let amount = Double(text) else {
            showAlert(title: "오류", message: "숫자를 입력해주세요")
            return
        }
        let result = detailViewModel.exchangeRate(inputNumber: amount)
        resultLabel.text = result
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    private func configureUI() {

        [labelStackView,amountTextField,convertButton,resultLabel]
            .forEach{view.addSubview($0)}

        [currencyLabel, countryLabel]
            .forEach{labelStackView.addArrangedSubview($0)}

        labelStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints{
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            //여기 검증해봐야됨
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        convertButton.snp.makeConstraints{
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints{
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

