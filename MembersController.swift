//
//  MembersController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/15/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

import UIKit

class MembersController: UITableViewController, MemberAddControllerDelegate {
    
    /////
    ///// Properties
    /////
    
    var membersArray = [Member]()
    
    
    
    /////
    ///// View Lifecycle
    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        // get members from Firebase
        let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members")
        ref.observeEventType(FEventType.ChildAdded, withBlock: {
            (snapshot) in
            var firstName = snapshot.value.objectForKey("fName") as? String
            // put retrieved data in Member object
            if (firstName != nil) {
                let member = Member()
                member.fName = firstName!
                self.membersArray.append(member)
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    /////
    ///// Tableview methods
    /////

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath) as UITableViewCell
        let member = membersArray[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        label.text = member.fName
        return cell
    }
    
    
    
    /////
    ///// MemberAddControllerDelegate methods
    /////
    
    func memberAddControllerDidCancel(controller: MemberAddController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func memberAddController(controller: MemberAddController, didFinishAddingMember member: Member) {
        // add member to Firebase
        let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members")
        
        let idRef = ref.childByAutoId() //unique memberId
        idRef.setValue([
            "fName":member.fName,
            "lName":member.lName,
            "ssn":member.ssn,
            "dob":member.dob,
            "email":member.email,
            "phone":member.phone,
            "street1":member.street1,
            "street2":member.street2,
            "city":member.city,
            "state":member.state,
            "zip":member.zip
            ])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /////
    ///// Navigation
    /////
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddMember" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MemberAddController
            controller.delegate = self
        }
    }

    

}
