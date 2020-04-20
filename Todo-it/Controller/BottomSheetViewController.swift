//
//  BottomSheetViewController.swift
//  Todo-it
//
//  Created by Mohaned Yossry on 4/18/20.
//  Copyright © 2020 Mohaned Yossry. All rights reserved.
//

import UIKit
import BottomPopup

class BottomSheetViewController: BottomPopupViewController{
    
    @IBOutlet weak var todoTextField: UITextField!
    var delegate:BottomSheetDelegate?
    var type:EntryType = .item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .category {
            todoTextField.placeholder = "Enter Category"
        }
    }
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return CGFloat(10) }
    
    override var popupPresentDuration: Double { return  1.0 }
    
    override var popupDismissDuration: Double { return 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool {
        
        return true
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        if todoTextField.text != "" {
            delegate?.itemIsAdded(text: todoTextField.text!)
            todoTextField.text = ""
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}
//MARK: - This Protocol to pass data back

protocol BottomSheetDelegate {
    func itemIsAdded(text: String)
}

//MARK: - This Enum to identify between Category and Item
enum EntryType{
    case item
    case category
}
