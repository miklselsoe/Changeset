//
//  UIKit+Changeset.swift
//  Copyright (c) 2016 Joachim Bondo. All rights reserved.
//

import UIKit

public extension UITableView {
	
	/// Performs batch updates on the table view, given a Changeset, and animates the transition.
	public func updateWithChangeset<T: CollectionType where T.Generator.Element: Equatable, T.Index.Distance == Int> (changeset: Changeset<T>, inSection section: Int) {
		
		guard !changeset.edits.isEmpty else { return }
		
		let indexPaths = batchIndexPathsFromChangeset(changeset, inSection: section)
		
		self.beginUpdates()
		if !indexPaths.deletions.isEmpty { self.deleteRowsAtIndexPaths(indexPaths.deletions, withRowAnimation: .Automatic) }
		if !indexPaths.insertions.isEmpty { self.insertRowsAtIndexPaths(indexPaths.insertions, withRowAnimation: .Automatic) }
		if !indexPaths.updates.isEmpty { self.reloadRowsAtIndexPaths(indexPaths.updates, withRowAnimation: .Automatic) }
		indexPaths.moves.forEach { self.moveRowAtIndexPath($0.from, toIndexPath: $0.to) }
		self.endUpdates()
	}
}

public extension UICollectionView {
	
	/// Performs batch updates on the table view, given a Changeset, and animates the transition.
	public func updateWithChangeset<T: CollectionType where T.Generator.Element: Equatable, T.Index.Distance == Int> (changeset: Changeset<T>, inSection section: Int, completion: ((Bool) -> Void)?) {
		
		guard !changeset.edits.isEmpty else { return }
		
		let indexPaths = batchIndexPathsFromChangeset(changeset, inSection: section)
		
		self.performBatchUpdates({
			if !indexPaths.deletions.isEmpty { self.deleteItemsAtIndexPaths(indexPaths.deletions) }
			if !indexPaths.insertions.isEmpty { self.insertItemsAtIndexPaths(indexPaths.insertions) }
			if !indexPaths.updates.isEmpty { self.reloadItemsAtIndexPaths(indexPaths.updates) }
			indexPaths.moves.forEach { self.moveItemAtIndexPath($0.from, toIndexPath: $0.to) }
			}, completion: completion)
	}
}

internal func batchIndexPathsFromChangeset<T: CollectionType where T.Generator.Element: Equatable, T.Index.Distance == Int> (changeset: Changeset<T>, inSection section: Int) -> (insertions: [NSIndexPath], deletions: [NSIndexPath], moves: [(from: NSIndexPath, to: NSIndexPath)], updates: [NSIndexPath]) {
	
	var insertions = [NSIndexPath]()
	var deletions = [NSIndexPath]()
	var moves = [(from: NSIndexPath, to: NSIndexPath)]()
	var updates = [NSIndexPath]()
	
	for edit in changeset.edits {
		let destinationIndexPath = NSIndexPath(forRow: edit.destination, inSection: section)
		switch edit.operation {
		case .Deletion:
			deletions.append(destinationIndexPath)
		case .Insertion:
			insertions.append(destinationIndexPath)
		case .Move(let origin):
			let originIndexPath = NSIndexPath(forRow: origin, inSection: section)
			moves.append(from: originIndexPath, to: destinationIndexPath)
		case .Substitution:
			updates.append(destinationIndexPath)
		}
	}
	
	return (insertions: insertions, deletions: deletions, moves: moves, updates: updates)
}
