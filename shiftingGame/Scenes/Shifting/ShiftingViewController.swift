//
//  ShiftingViewController.swift
//  shiftingGame
//
//  Created by Rodrigo Astorga on 11-07-20.
//  Copyright © 2020 Rodrigo Astorga. All rights reserved.
//

import UIKit

class ShiftingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let heightCell: CGFloat = 50.0
    private let widthCell: CGFloat = 50.0
    
    
    private var dataSource: ShiftingCollectionDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
}

// MARK: - Life Cycle
extension ShiftingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let uiNib = UINib(nibName: String(describing: NumberCollectionViewCell.self), bundle: nil)
        collectionView.register(uiNib, forCellWithReuseIdentifier: String(describing: NumberCollectionViewCell.self))
        let array = Array(1...9)
        dataSource = ShiftingCollectionDataSource(with: array)
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate

extension ShiftingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        return CGSize(width: widthCell, height: heightCell)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt _: Int
    ) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }

        var insets = flowLayout.sectionInset
        insets.left = 16

        let padding = (collectionView.frame.height - heightCell) / 2
        insets.top = padding
        insets.bottom = padding

        return insets
    }
}

