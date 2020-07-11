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
    var submitInputAction = UIAlertAction()
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private var cellsPerRow = 3
    
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
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInputSize()
    }
}

extension ShiftingViewController {
    
    private func setupCollectionView(sizeOfMatrix: Int) {
        cellsPerRow = sizeOfMatrix
        let longitudeArray = cellsPerRow * cellsPerRow
        let array = Array(1...longitudeArray)
        dataSource = ShiftingCollectionDataSource(with: array)
        dataSource?.shuffle()
        collectionView.reloadData()
    }
    private func showInputSize() {
        let alertController = UIAlertController(
            title: "Enter size of the grid",
            message: "",
            preferredStyle: .alert
        )

        alertController.addTextField { [weak self] (textField : UITextField!) -> Void in
            textField.placeholder = "example: 3"
            textField.delegate = self
        }

        submitInputAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            (alertController.textFields?.first)?.text.map { text in
                let textInt = Int(text) ?? 0
                self?.setupCollectionView(sizeOfMatrix: textInt)
            }
        })
        submitInputAction.isEnabled = false

        alertController.addAction(submitInputAction)

        self.present(alertController, animated: true, completion: nil)
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

// MARK: - CollectionView Drag and drop

extension ShiftingViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let dataSource = dataSource else {
            return [UIDragItem]()
        }
        
        let item = dataSource.number(at: indexPath.row)
        let itemProvider = NSItemProvider(object: String(item ?? 0) as NSString )
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag
        {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    //MARK: Private Methods
    /// extract from: https://hackernoon.com/drag-it-drop-it-in-collection-table-ios-11-6bd28795b313
    /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item. If multiple items selected, no reordering happens.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func reorderItems(
        coordinator: UICollectionViewDropCoordinator,
        destinationIndexPath: IndexPath,
        collectionView: UICollectionView
    ) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            
            collectionView.performBatchUpdates({
                dataSource?.remove(at: sourceIndexPath)
                dataSource?.insert(value: item.dragItem.localObject as! Int, at: dIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
                let isOrdered = dataSource?.isOrdered() ?? false
                if isOrdered {
                    showAlert()
                }
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "You Won!",
            message: "The numbers are ordered",
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
}

extension ShiftingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), !text.isEmpty {
            submitInputAction.isEnabled = true
        } else {
            submitInputAction.isEnabled = false
        }
        return true
    }
}

