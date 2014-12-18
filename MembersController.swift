//
//  MembersController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/15/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

/////
///// yes Firebase code
/////

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
        tableView.rowHeight = 60
        
        // get members from Firebase
        let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members")
        ref.queryOrderedByChild("lName").observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let memberDict = snapshot.value as NSDictionary
            var memberObj = Member()
            memberObj.memberId = memberDict["memberId"] as String!
            memberObj.fName = memberDict["fName"] as String!
            memberObj.lName = memberDict["lName"] as String!
            memberObj.ssn = memberDict["ssn"] as String!
            memberObj.dob = memberDict["dob"] as String!
            memberObj.email = memberDict["email"] as String!
            memberObj.phone = memberDict["phone"] as String!
            memberObj.street1 = memberDict["street1"] as String!
            memberObj.street2 = memberDict["street2"] as String!
            memberObj.city = memberDict["city"] as String!
            memberObj.state = memberDict["state"] as String!
            memberObj.zip = memberDict["zip"] as String!
            memberObj.sponsorId = memberDict["sponsorId"] as String!
            
            self.membersArray.append(memberObj)
            
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
        
        if member.fName == "Al" && member.lName == "Ricotta" {
            cell.accessoryType = .None
        }
        
        let nameLabel = cell.viewWithTag(1000) as UILabel
        nameLabel.text = member.lName + ", " + member.fName
        
        let phoneLabel = cell.viewWithTag(1001) as UILabel
        phoneLabel.text = member.phone
        
        //let emailLabel = cell.viewWithTag(1002) as UILabel
        //emailLabel.text = member.email
        
        return cell
    }
    
    // accessory selected
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
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
            "memberId":idRef.key,
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
            "zip":member.zip,
            "sponsorId":member.sponsorId
        ])
        // start constructing the members tree - their upline (they don't have a downline yet - obviously!)
        // TODO: get s1 and s2
        let treeRef = Firebase(url: "https://archerswift.firebaseio.com/v1/tree/\(idRef.key)")
        treeRef.setValue([
            "s1":member.sponsorId,
            "s2":"",
            "s3":""
        ])
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func memberAddController(controller: MemberAddController, didFinishEditingMember member: Member) {
        // the memberID of the member to edit
        let memberId = member.memberId
        
        // get the ref of the member
        let memberRef = Firebase(url: "https://archerswift.firebaseio.com/v1/members/\(memberId)")
        
        memberRef.updateChildValues([
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
            "zip":member.zip,
            "sponsorId":member.sponsorId
            ])
        
        dismissViewControllerAnimated(true, completion: nil)
        
        self.tableView.reloadData()
    }
    
    
    
    /////
    ///// Navigation
    /////
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // barButtonItem - just set self as delegate for MemberAddController
        if segue.identifier == "AddMember" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MemberAddController
            controller.delegate = self
         
        // accessory button - set self as delegate for MemberAddController
        // pass the selected member to the MemberAddController to edit
        } else if segue.identifier == "EditMember" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MemberAddController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                let selectedMember = membersArray[indexPath.row]
                controller.memberToEdit = selectedMember
                
                // get the sponsor from Firebase
                let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members/\(selectedMember.sponsorId)")
                ref.observeEventType(FEventType.Value, withBlock: { (snapshot) in
                    let sponsorDict = snapshot.value as NSDictionary
                    var sponsorObj = Member()
                    sponsorObj.memberId = sponsorDict["memberId"] as String!
                    sponsorObj.fName = sponsorDict["fName"] as String!
                    sponsorObj.lName = sponsorDict["lName"] as String!
                    sponsorObj.phone = sponsorDict["phone"] as String!
                    
                    controller.selectedSponsor = sponsorObj
                })
            }
            
        // select row - pass the selected member to the MemberMenuController
        } else if segue.identifier == "ShowMemberMenu" {
            let controller = segue.destinationViewController as MemberMenuController
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                controller.selectedMember = membersArray[indexPath.row]
            }
        }
    }

    

}
