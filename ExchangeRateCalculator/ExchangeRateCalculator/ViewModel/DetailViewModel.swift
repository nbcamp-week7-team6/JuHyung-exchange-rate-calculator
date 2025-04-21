//
//  DetailViewModel.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/21/25.
//

struct DetailViewModel {
    private let rate: CurrencyRate


    init(rate: CurrencyRate) {
        self.rate = rate
    }
    
    var currencyCode: String {
        return rate.currencyCode
    }

    var countryName: String {
        return rate.country
    }

    var formattedRate: String {
        return String(format: "%.4f", rate.rate)
    }
    //
//    static func exchangeRate(input: Double, basedCurrency: Double, counterCurreny: Double) -> String {
//        //변환 결과 = 입력 금액 × 대상 통화 환율 / 기준 통화 환율
//        let resultRate = (input * counterCurreny) / basedCurrency
//        let formattedResult = String(format: "%.2f", resultRate)
//        return "$\(input) -> \(formattedResult) \(currencycode)"
//    }
}
