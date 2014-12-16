//
//  MemberAddController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/15/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

import UIKit

protocol MemberAddControllerDelegate: class {
    func memberAddControllerDidCancel(controller: MemberAddController)
    func memberAddController(controller:MemberAddController, didFinishAddingMember member:Member)
}

class MemberAddController: UITableViewController, UITextFieldDelegate {
    
    /////
    ///// Properties
    /////
    
    weak var delegate: MemberAddControllerDelegate?
    
    
    
    /////
    ///// Outlets
    /////
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ssnTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var street1TextField: UITextField!
    @IBOutlet weak var street2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    
    
    
    
    
    /////
    ///// View Lifecycle
    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.becomeFirstResponder()
    }
    
    
    
    /////
    ///// IBActions
    /////
    
    @IBAction func cancel() {
        delegate?.memberAddControllerDidCancel(self)
    }
    
    
    @IBAction func doneBtnPressed() {
        // create a new member and send to delegate
        let newMember = Member()
        newMember.fName = firstNameTextField.text
        newMember.lName = lastNameTextField.text
        newMember.ssn = ssnTextField.text
        newMember.dob = dobTextField.text
        newMember.email = emailTextField.text
        newMember.phone = phoneTextField.text
        newMember.street1 = street1TextField.text
        newMember.street2 = street2TextField.text
        newMember.city = cityTextField.text
        newMember.state = stateTextField.text
        newMember.zip    = zipTextField.text
        
        delegate?.memberAddController(self, didFinishAddingMember: newMember)

    }
    
    
    
    /////
    ///// UITextfieldDelegate methods
    /////
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.length > 0 {
            doneBtn.enabled = true
        } else {
            doneBtn.enabled = false
        }
        return true
    }
    
    
    /////
    ///// UITableView methods
    /////
    
    // prevents user from selecting cell
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    

}
