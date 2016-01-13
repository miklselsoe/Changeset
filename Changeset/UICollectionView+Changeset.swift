//
//  UICollectionView+Changeset.swift
//  Pods
//
//  Created by Mikkel Selsøe Sørensen on 13/01/2016.
//
//

import Foundation

import UIKit

extension UICollectionView {
    
    /// Performs batch updates on the collection view. Given a Changeset, deletions and insertions will be animated on the collection view.
    public func updateWithChangeset<T: CollectionType where T.Generator.Element: Equatable, T.Index.Distance == Int> (changeset: Changeset<T>, completion: ((Bool) -> Void)?) {
        
        guard !changeset.edits.isEmpty else { return }
        
        let arrays = changeset.batchChangeArrays()
        
        self.performBatchUpdates({ () -> Void in
            if !arrays.deletions.isEmpty { self.deleteItemsAtIndexPaths(arrays.deletions) }
            if !arrays.insertions.isEmpty { self.insertItemsAtIndexPaths(arrays.insertions) }
            if !arrays.updates.isEmpty { self.reloadItemsAtIndexPaths(arrays.updates) }
            }, completion: completion)
    }
}
