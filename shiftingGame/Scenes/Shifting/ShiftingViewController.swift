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
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private let cellsPerRow = 3
    
    private let matrixNumber = 3
    
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
        
        let longitudeArray = matrixNumber * matrixNumber
        let array = Array(1...longitudeArray)
        dataSource = ShiftingCollectionDataSource(with: array)
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate

extension ShiftingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return minimumLineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return minimumInteritemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left +
            collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

