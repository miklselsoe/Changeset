//
//  UITableView+Changeset.swift
//  Pods
//
//  Created by Mikkel Selsøe Sørensen on 13/01/2016.
//
//

import UIKit

extension UITableView {
    
    /// Performs batch updates on the table view. Given a Changeset, deletions and insertions will be animated on the table view.
    public func updateWithChangeset<T: CollectionType where T.Generator.Element: Equatable, T.Index.Distance == Int> (changeset: Changeset<T>) {
        
        guard !changeset.edits.isEmpty else { return }
        
        let arrays = changeset.batchChangeArrays()
        
        self.beginUpdates()
        if !arrays.deletions.isEmpty { self.deleteRowsAtIndexPaths(arrays.deletions, withRowAnimation: .Automatic) }
        if !arrays.insertions.isEmpty { self.insertRowsAtIndexPaths(arrays.insertions, withRowAnimation: .Automatic) }
        if !arrays.updates.isEmpty { self.reloadRowsAtIndexPaths(arrays.updates, withRowAnimation: .Automatic) }
        self.endUpdates()
        
    }
}
