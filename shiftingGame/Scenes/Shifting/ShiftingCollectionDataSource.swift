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

    func number(at index: Int) -> Int? {
        return dataOrganizer[index]
    }
    
    func isOrdered() {
        // TODO: agregar validación para saber si el array está ordenado
    }
    
    func shuffle() {
        // TODO: cambia el orden del array
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
