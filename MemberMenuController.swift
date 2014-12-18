//
//  MemberMenuController.swift
//  archerswift
//
//  Created by Al Ricotta on 12/16/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

/////
///// no Firebase code
/////

import UIKit

class MemberMenuController: UITableViewController {
    
    /////
    ///// Properties
    /////
    
    var selectedMember: Member!
    
    
    
    /////
    ///// View lifecycle
    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        let firstName = selectedMember.fName
        let lastName = selectedMember.lName
        title = firstName.substringToIndex(advance(firstName.startIndex, 1)) + " " + selectedMember.lName
    }

}
