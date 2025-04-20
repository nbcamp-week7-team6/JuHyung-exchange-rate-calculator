//
//  TableViewCell.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/20/25.
//
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {

    static let id = "TableViewCell"

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right

        return label
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    let backView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {
        contentView.addSubview(backView)

        [currencyCodeLabel, countryLabel]
            .forEach{ labelStackView.addArrangedSubview($0)}

        [labelStackView, rateLabel]
            .forEach{ backView.addSubview($0)}

        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }

        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

    func configure(currencyCode: String, rate: Double) {
        guard let countryName = CountryMapping[currencyCode] else {
            return print("매핑된 정보 없습니다.")
        }
        currencyCodeLabel.text = currencyCode
        countryLabel.text = countryName
        rateLabel.text = String(format: "%.4f", rate)
    }
}

