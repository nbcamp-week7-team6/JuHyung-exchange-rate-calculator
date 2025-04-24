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

//    private let cellViewModel: CellViewModel
    var closureBookmarkTapped: (() -> Void)?


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

    private let leftLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let bookMarkImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.image = UIImage(systemName: "star")
        uiImageView.tintColor = .systemYellow
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.isUserInteractionEnabled = true
        return uiImageView
    }()

    private let rightItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
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
            .forEach{ leftLabelStackView.addArrangedSubview($0)}

        [rateLabel, bookMarkImageView]
            .forEach{ rightItemsStackView.addArrangedSubview($0)}

        [leftLabelStackView, rightItemsStackView]
            .forEach{ backView.addSubview($0)}

        leftLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        rightItemsStackView.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(leftLabelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }

        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }

        bookMarkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookMarkTapped)))
    }

    private var isBookmarked = false

    func toggleBookmark(is toggled: Bool){
        let imageState = toggled ? "star.fill" : "star"
        bookMarkImageView.image = UIImage(systemName: imageState)
    }


    @objc private func bookMarkTapped(){
        isBookmarked.toggle()
        toggleBookmark(is: isBookmarked)
        closureBookmarkTapped?()
    }

//    func configure(currencyInnerItem: CurrencyRate, fromVCBookMarkTapped: Bool) {
//        guard let countryName = CountryMapping[currencyInnerItem.currencyCode] else {
//            return print("매핑된 정보 없습니다.")
//        }
//        currencyCodeLabel.text = currencyInnerItem.currencyCode
//        countryLabel.text = countryName
//        rateLabel.text = String(format: "%.4f", currencyInnerItem.rate)
//        toggleBookmark(is: fromVCBookMarkTapped)
//        self.isBookmarked = fromVCBookMarkTapped
//    }

    func configure(currencyCode: String, rate: Double, fromVCBookMarkTapped: Bool) {
        currencyCodeLabel.text = currencyCode
        countryLabel.text = CountryMapping[currencyCode] ?? ""
        rateLabel.text = String(format: "%.4f", rate)
        toggleBookmark(is: fromVCBookMarkTapped)
        self.isBookmarked = fromVCBookMarkTapped
    }

}

