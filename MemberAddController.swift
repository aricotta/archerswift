//
//  MemberAddController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/15/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

/////
///// no Firebase code
/////

import UIKit

protocol MemberAddControllerDelegate: class {
    func memberAddControllerDidCancel(controller: MemberAddController)
    func memberAddController(controller:MemberAddController, didFinishAddingMember member:Member)
    func memberAddController(controller:MemberAddController, didFinishEditingMember member:Member)
}

class MemberAddController: UITableViewController, UITextFieldDelegate, SelectSponsorControllerDelegate {
    
    /////
    ///// Properties
    /////
    
    weak var delegate: MemberAddControllerDelegate?
    var memberToEdit: Member?  //only when editing an existing member
    var existingSponsor: Member? //only when editing an existing member - need to fill in referredByTextField
    var selectedSponsor: Member?  //only when adding new member
    
    
    
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
    
    @IBOutlet weak var referredByLabel: UILabel!
    @IBOutlet weak var selectMemberBtn: UIButton!
    
    
    /////
    ///// View Lifecycle
    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        // if we are editing an existing member...
        if let member = memberToEdit {
            title = "Edit Member"
            doneBtn.enabled = true
            firstNameTextField.text = member.fName
            lastNameTextField.text = member.lName
            ssnTextField.text = member.ssn
            dobTextField.text = member.dob
            emailTextField.text = member.email
            phoneTextField.text = member.phone
            street1TextField.text = member.street1
            street2TextField.text = member.street2
            cityTextField.text = member.city
            stateTextField.text = member.state
            zipTextField.text = member.zip
            
            if let sponsor = selectedSponsor {
                referredByLabel.text = sponsor.fName + " " + sponsor.lName
            }
            
            // can't change sponsor once assigned
            selectMemberBtn.enabled = false // disable btn
            selectMemberBtn.tintColor = UIColor(white: 0, alpha: 0) // make btn white
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        enableDoneButton()
        firstNameTextField.becomeFirstResponder()
        street2TextField.enablesReturnKeyAutomatically = false //user input not required
    }
    
    
    
    /////
    ///// IBActions
    /////
    
    @IBAction func cancel() {
        delegate?.memberAddControllerDidCancel(self)
    }
    
    @IBAction func doneBtnPressed() {
        if let member = memberToEdit {
            // edit the member
            member.fName = firstNameTextField.text
            member.lName = lastNameTextField.text
            member.ssn = ssnTextField.text
            member.dob = dobTextField.text
            member.email = emailTextField.text
            member.phone = phoneTextField.text
            member.street1 = street1TextField.text
            member.street2 = street2TextField.text
            member.city = cityTextField.text
            member.state = stateTextField.text
            member.zip = zipTextField.text
            //member.sponsorId = referredByLabel.text! // can't change sponsor
            delegate?.memberAddController(self, didFinishEditingMember: member)
        } else {
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
            newMember.zip = zipTextField.text
            if let sponsor = selectedSponsor {
                newMember.sponsorId = sponsor.memberId
            }
            delegate?.memberAddController(self, didFinishAddingMember: newMember)
        }
    }
    
    // only enabled when adding a new member (not editing one)
    @IBAction func selectMemberBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("SelectSponsor", sender: nil)
        
    }
    
    
    
    /////
    ///// UITextfieldDelegate methods
    /////
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = textField.text
        let newText: NSString = currentText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.length > 0 {
            enableDoneButton()
        } else {
            doneBtn.enabled = false
        }
        return true
    }
    
    // move to next textfield when Next button pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch (textField) {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            ssnTextField.becomeFirstResponder()
        case ssnTextField:
            dobTextField.becomeFirstResponder()
        case dobTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            street1TextField.becomeFirstResponder()
        case street1TextField:
            street2TextField.becomeFirstResponder()
        case street2TextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            stateTextField.becomeFirstResponder()
        case stateTextField:
            zipTextField.becomeFirstResponder()
        case zipTextField:
            referredByLabel.becomeFirstResponder()
        default:
            firstNameTextField.becomeFirstResponder()
        }
        enableDoneButton()
        return true
    }
    
    
    
    /////
    ///// UITableView methods
    /////
    
    // prevents user from selecting cell
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    
    
    /////
    ///// Custom methods
    /////
    
    func enableDoneButton() {
        var enabled = true
        
        // enabled = enabled + expression
        enabled &= !(firstNameTextField.text == "")
        enabled &= !(lastNameTextField.text == "")
        enabled &= !(dobTextField.text == "")
        enabled &= !(ssnTextField.text == "")
        enabled &= !(emailTextField.text == "")
        enabled &= !(phoneTextField.text == "")
        enabled &= !(street1TextField.text == "")
        enabled &= !(cityTextField.text == "")
        enabled &= !(stateTextField.text == "")
        enabled &= !(zipTextField.text == "")
        
        doneBtn.enabled = enabled
    }
    
    
    
    /////
    ///// Navigation
    /////
    
    // select sponsor button pressed - set self as delegate for SelectSponsorController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectSponsor" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as SelectSponsorController
            controller.delegate = self
        }
    }
    
    
    
    /////
    ///// SelectSponsorControllerDelegate methods
    /////
    
    func selectSponsorControllerDidCancel(controller: SelectSponsorController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // member selected in SelectSponsorController passed here
    // in order to assign a sponsor to a new member
    func selectSponsorContoller(controller: SelectSponsorController, didSelectSponsor sponsor: Member) {
        dismissViewControllerAnimated(true, completion: nil)
        selectedSponsor = sponsor
        referredByLabel.text = sponsor.fName + " " + sponsor.lName
    }
    
}
