//
//  SearchBar.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/21/25.
//
import Foundation

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var action: ((Action) -> Void)? { get }
    var stateChanged: ((State) -> Void)? { get set }
}

enum ExchangeAction {
    case fetch
    case filter(text: String)
}

struct ExchangeState {
    var filteredRates: [CurrencyRate]
    var baseCurrency: CurrencyRate?
    var errorMessage: String?
    //    let isBookmarked: Bool
}


class ViewModel: ViewModelProtocol {

    typealias Action = ExchangeAction
    typealias State = ExchangeState
    private let apiService = APIService()
    let coreDataManager = CoreDataManager.shared

    var action: ((ExchangeAction) -> Void)?
    var stateChanged: ((ExchangeState) -> Void)?


    //viewModel의 접근제어 set 내부에서만 쓰기 가능 외부 읽기 x -> 변경함 model안으로 변수를 옮겨서
    //상태만 저장
    var allRates: [CurrencyRate] = []
    var filteredRates: [CurrencyRate] = []
    var baseCurrency: CurrencyRate?

    init() {
        bind()
    }

    func bind() {
        self.action = { [weak self] action in
            guard let self = self else { return }

            switch action {
            case .fetch:
                self.fetchCurrentRateData()

            case .filter(let text):
                self.filterRates(with: text)
            }
        }
    }
    func setRates(_ rates: [CurrencyRate]) {
        allRates = rates
        filteredRates = rates
        applyState()

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
        applyState()
    }

    func fetchCurrentRateData() {
        let urlComponents = URLComponents(string: "https://open.er-api.com/v6/latest/USD")

        print(#fileID, #function, #line, "print urlComponents?.url: \(String(describing: urlComponents?.url))")
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }

        apiService.fetchData(url: url) { [weak self] (result: ModelData?) in
            guard let self else { return }

            guard let result else {
                let errorMessage = ExchangeState(
                    filteredRates: [], errorMessage: "데이터를 불러올 수 없습니다."
                )
                self.stateChanged?(errorMessage)
                return
            }

            //미국 기준 환율 가져오기
            let baseCode = result.baseCode
            guard let baseRate = result.rates[baseCode] else { return }
            self.baseCurrency = CurrencyRate(currencyCode: baseCode, country: "USD", rate: baseRate)

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
            //  MARK: -- 문제 발견 guard let 을 쓰니 map과정에서 return nil 발생
            //            let mappingData = result.rates.map{ (key, value) in
            //                guard let countryName = CountryMapping[key] else {
            //                    return
            //                }
            //                CurrencyRate(currencyCode: key, country: countryName, rate: value)}
            //            self.currencyRates = mappingData.sorted(by: {$0.currencyCode < $1.currencyCode})
            let sortedData = mappingData.sorted(by: {$0.currencyCode < $1.currencyCode})
            self.setRates(sortedData)
        }
    }

    private func applyState() {
        DispatchQueue.main.async {
            let state = ExchangeState(
                filteredRates: self.filteredRates,
                baseCurrency: self.baseCurrency
                //            isBookmarked:
            )
            self.stateChanged?(state)
        }
    }

    func fetchAndSortRatesFromCoreData() {
        let bookmarkedCodes = coreDataManager.fetchCurrencyCodeSortedByFavorites().compactMap { $0.currencyCode }

        let sorted = allRates.sorted {
            let isFirst = bookmarkedCodes.contains($0.currencyCode)
            let isSecond = bookmarkedCodes.contains($1.currencyCode)

            if isFirst != isSecond {
                return isFirst
            } else {
                return $0.currencyCode < $1.currencyCode
            }
        }

        self.filteredRates = sorted
        DispatchQueue.main.async {
                self.applyState()
            }
    }

    func toggleBookmark(for code: String) {
        if coreDataManager.returnBookMark(code: code) {
            coreDataManager.deleteCurrencyCode(code)
            print("즐찾 해제")
        } else {
            coreDataManager.saveCurrencyCode(code)
            print("즐찾 성공")
        }

        fetchAndSortRatesFromCoreData()
    }




}
