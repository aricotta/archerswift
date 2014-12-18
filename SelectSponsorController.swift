//
//  SelectSponsorController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/17/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

/////
///// yes Firebase code
/////

import UIKit

protocol SelectSponsorControllerDelegate: class {
    func selectSponsorControllerDidCancel(controller:SelectSponsorController)
    func selectSponsorContoller(controller:SelectSponsorController, didSelectSponsor sponsor:Member)
}

class SelectSponsorController: UITableViewController {
    
    /////
    ///// Properties
    /////
    
    var sponsorsArray = [Member]()
    weak var delegate: SelectSponsorControllerDelegate?
    
    
    
    /////
    ///// View Lifecycle
    /////

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        // get all members from Firebase to select as a sponsor
        let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members")
        ref.queryOrderedByChild("lName").observeEventType(FEventType.ChildAdded, withBlock: {
            (snapshot) in
            
            let sponsorDict = snapshot.value as NSDictionary
            var sponsorObj = Member()
            sponsorObj.memberId = sponsorDict["memberId"] as String!
            sponsorObj.fName = sponsorDict["fName"] as String!
            sponsorObj.lName = sponsorDict["lName"] as String!
            sponsorObj.phone = sponsorDict["phone"] as String!
            self.sponsorsArray.append(sponsorObj)
            
            self.tableView.reloadData()
        })
    }

    
    /////
    ///// Tableview methods
    /////

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsorsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectSponsorCell", forIndexPath: indexPath) as UITableViewCell
        let sponsor = sponsorsArray[indexPath.row]
        // fill in sponsors name
        let nameLabel = cell.viewWithTag(2000) as UILabel
        nameLabel.text = sponsor.lName + ", " + sponsor.fName
        // fill in sponsors phone number
        let phoneLabel = cell.viewWithTag(2010) as UILabel
        phoneLabel.text = sponsor.phone
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSponsor = sponsorsArray[indexPath.row]
        // tell delegate a row was selected - pass the selected sponsor to the delegate
        delegate?.selectSponsorContoller(self, didSelectSponsor: selectedSponsor)
    }
    
    
    
    /////
    ///// IBAction methods
    /////
    
    @IBAction func cancel() {
        // tell delegate cancel button was pressed
        delegate?.selectSponsorControllerDidCancel(self)
    }

}
