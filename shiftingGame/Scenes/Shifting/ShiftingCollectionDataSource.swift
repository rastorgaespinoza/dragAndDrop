//
//  ShiftingCollectionDataSource.swift
//  shiftingGame
//
//  Created by Rodrigo Astorga on 11-07-20.
//  Copyright © 2020 Rodrigo Astorga. All rights reserved.
//

import UIKit

class ShiftingCollectionDataSource: NSObject {
    private var dataOrganizer: DataOrganizer

    init(with numbers: [Int]) {
        dataOrganizer = DataOrganizer(items: numbers)
        super.init()
    }
    
    func allNumbers() -> [Int]{
        return dataOrganizer.items
    }

    func number(at index: Int) -> Int? {
        return dataOrganizer[index]
    }
    
    func isOrdered() -> Bool {
        let sortedArray = dataOrganizer.items.sorted(by: <)
        return sortedArray == dataOrganizer.items
    }
    
    func shuffle() {
        if isOrdered() {
            dataOrganizer.items.shuffle()
            shuffle()
        }
    }
    
    func remove(at indexPath: IndexPath) {
        dataOrganizer.remove(at: indexPath.item)
    }
    
    func insert(value: Int, at indexPath: IndexPath) {
        dataOrganizer.insert(value, at: indexPath.item)
    }
}

private extension ShiftingCollectionDataSource {
    struct DataOrganizer {
        var items: [Int]

        var itemsCount: Int {
            return items.count
        }

        subscript(index: Int) -> Int? {
            if index >= itemsCount {
                return nil
            }
            return items[index]
        }
        
        mutating func remove(at index: Int) {
            items.remove(at: index)
        }
        
        mutating func insert(_ value: Int, at index: Int) {
            items.insert(value, at: index)
        }
    }
}

extension ShiftingCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return dataOrganizer.itemsCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: NumberCollectionViewCell.self),
            for: indexPath
        )
        (cell as? NumberCollectionViewCell).map {
            $0.numberLabel.text = "\(number(at: indexPath.item) ?? 0)"
        }
        return cell
    }
}
