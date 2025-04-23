//
//  CellViewModel.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/23/25.
//
import Foundation

//protocol CellViewModelProtocol {
//    associatedtype Action
//    associatedtype State
//
//    var action: ((Action) -> Void)? { get }
//    var stateChanged: ((State) -> Void)? { get set }
//}
//
//enum CellAction {
//    case click
//}
//
//struct CellState {
//    var Currency: CurrencyRate?
//    var bookMark: Bool
//}
//
//class CellViewModel: CellViewModelProtocol {
//
//    typealias Action = CellAction
//    typealias State = CellState
//
//    var action: ((CellAction) -> Void)?
//    var stateChanged: ((CellState) -> Void)?
//
//    let currencyCode: String
//    private var isBookmarked: Bool
//
////    init(rate: CurrencyRate, isBookmarked: Bool = false) {
////        self.currencyCode = rate.currencyCode
////        self.isBookmarked = isBookmarked
////    }
//    init(action: ( (CellAction) -> Void)? = nil, stateChanged: ( (CellState) -> Void)? = nil, currencyCode: String, isBookmarked: Bool) {
//        self.action = action
//        self.stateChanged = stateChanged
//        self.currencyCode = currencyCode
//        self.isBookmarked = isBookmarked
//    }
//
//    func toggleBookmark() {
//        isBookmarked.toggle()
//
//    }
//}
