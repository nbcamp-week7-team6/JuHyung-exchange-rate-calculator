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

    private let countryLabel = UILabel()
    private let rateLabel = UILabel()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {

        countryLabel.font = .systemFont(ofSize: 16)
        rateLabel.font = .systemFont(ofSize: 16)
        rateLabel.textAlignment = .right

        [countryLabel, rateLabel]
            .forEach{ contentStackView.addArrangedSubview($0)}

        [contentStackView]
            .forEach{ contentView.addSubview($0)}

        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with item: CurrencyRate) {
        countryLabel.text = item.countryCode
        rateLabel.text = String(format: "%.4f", item.rate)
    }
}

