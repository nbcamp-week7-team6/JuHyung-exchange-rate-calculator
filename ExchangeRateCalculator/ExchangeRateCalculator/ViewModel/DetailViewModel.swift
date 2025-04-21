//
//  DetailViewModel.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/21/25.
//

struct DetailViewModel {
    private let targetCurrency: CurrencyRate
    private let baseCurrency: CurrencyRate


    init(targetCurrency: CurrencyRate, baseCurrency: CurrencyRate) {
        self.targetCurrency = targetCurrency
        self.baseCurrency = baseCurrency
    }
    
    var currencyCode: String {
        return targetCurrency.currencyCode
    }

    var countryName: String {
        return targetCurrency.country
    }

    var formattedRate: String {
        return String(format: "%.4f", targetCurrency.rate)
    }


    func exchangeRate(inputNumber: Double) -> String {
        //변환 결과 = 입력 금액 × 대상 통화 환율 / 기준 통화 환율
        let resultRate = (inputNumber * targetCurrency.rate) / baseCurrency.rate
        let formattedResult = String(format: "%.2f", resultRate)
        return "$\(String(format: "%.2f", inputNumber)) -> \(formattedResult) \(targetCurrency.currencyCode)"
    }
}
