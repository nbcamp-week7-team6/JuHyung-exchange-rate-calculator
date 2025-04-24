//
//  CoreDataManager.swift
//  ExchangeRateCalculator
//
//  Created by 윤주형 on 4/23/25.
//
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext

    func saveCurrencyCode(_ code: String) {
        guard let context = context else { return }
        let newEntity = CurrencyEntity(context: context)
        newEntity.currencyCode = code

        do {
            try context.save()
            print("context에 저장됨")
        } catch {
            print("context 저장 실패 \(error.localizedDescription)")
        }
    }

    func deleteCurrencyCode(_ code: String) {
        guard let context = context else { return }
        let request: NSFetchRequest<CurrencyEntity> = CurrencyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", code)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
            print("삭제 성공")
        } catch {
            print("삭제 실패: \(error.localizedDescription)")
        }
    }

    func fetchCurrencyCodeSortedByFavorites() -> [CurrencyEntity] {
        guard let context = context else { return [] }
        let request: NSFetchRequest<CurrencyEntity> = CurrencyEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "isFavorite", ascending: false),
            NSSortDescriptor(key: "currencyCode", ascending: true)
        ]

        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("fetch 실패: \(error.localizedDescription)")
            return []
        }
    }

    func returnBookMark(code: String) -> Bool {
        guard let context = context else { return false }
        let request: NSFetchRequest<CurrencyEntity> = CurrencyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", code)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
