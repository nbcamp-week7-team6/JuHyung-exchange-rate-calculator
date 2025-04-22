//
//  SearchBar.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/21/25.
//
import Foundation

class ViewModel {

    private var allRates: [CurrencyRate] = []
    //viewModel의 접근제어 set 내부에서만 쓰기 가능 외부 읽기 x
    private(set) var filteredRates: [CurrencyRate] = []
    var baseCurrency: CurrencyRate?

    func setRates(_ rates: [CurrencyRate]) {
        allRates = rates
        filteredRates = rates
    }


    func filterRates(with text: String) {
        let trimmed = text.lowercased().trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty {
            filteredRates = allRates
        } else {
            filteredRates = allRates.filter {
                $0.currencyCode.lowercased().contains(trimmed) ||
                $0.country.lowercased().contains(trimmed)
            }
        }
    }
    
    func restoreRates() {
        filteredRates = allRates
    }
}
