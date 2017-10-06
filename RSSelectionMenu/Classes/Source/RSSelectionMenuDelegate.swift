//
//  RSSelectionMenuDelegate.swift
//  RSSelectionMenu
//
//  Created by Rushi on 29/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

/// UITableViewCellSelection
typealias UITableViewCellSelection = ((_ object: AnyObject, _ isSelected: Bool, _ selectedArray: DataSource) -> ())

class RSSelectionMenuDelegate: NSObject {

    // MARK: - Properties
    
    /// tableview cell selection delegate
    public var selectionDelegate: UITableViewCellSelection? = nil
    
    /// selected objects
    fileprivate var selectedObjects: DataSource = []
    
    // MARK: - Initialize
    convenience init(delegate: @escaping UITableViewCellSelection) {
        self.init()
        
        self.selectionDelegate = delegate
    }
}

// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// action handler for single selection tableview
    fileprivate func handleActionForSingleSelection(object: AnyObject, tableView: RSSelectionTableView) {
        
        // remove all
        selectedObjects.removeAll()
        
        // add to selected list
        selectedObjects.append(object)
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, true, selectedObjects)
        }
    }
    
    /// action handler for multiple selection tableview
    fileprivate func handleActionForMultiSelection(object: AnyObject, tableView: RSSelectionTableView) {
        
        // is selected
        var isSelected = false
        
        // remove if already selected
        if let selectedIndex = tableView.isSelected(object: object, from: selectedObjects) {
            selectedObjects.remove(at: selectedIndex)
        }
        else {
            selectedObjects.append(object)
            isSelected = true
        }
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, isSelected, selectedObjects)
        }
    }
    
}

// MARK:- Public
extension RSSelectionMenuDelegate {
    
    /// add new object to selected array
    func addToSelected(object: AnyObject, forTableView: RSSelectionTableView) {
        
        guard forTableView.isSelected(object: object, from: selectedObjects) != nil else {
            selectedObjects.append(object)
            return
        }
    }
}

// MARK:- UITableViewDelegate
extension RSSelectionMenuDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let selectionTableView = tableView as! RSSelectionTableView
        
        // selected object
        let dataObject = selectionTableView.objectAt(indexPath: indexPath)
        
        // single selection
        if selectionTableView.selectionType == .single {
            handleActionForSingleSelection(object: dataObject, tableView: selectionTableView)
        }
        else {
            // multiple selection
            handleActionForMultiSelection(object: dataObject, tableView: selectionTableView)
        }
        
        // dismiss if required
        selectionTableView.dismissControllerIfRequired()
    }
}
