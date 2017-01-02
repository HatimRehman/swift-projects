//
//  AllQandAsViewController.swift
//  Pollster
//
//  Created by Hatim Rehman on 2016-07-25.
//  Copyright © 2016 Hatim. All rights reserved.
//

import UIKit
import CloudKit

class AllQandAsViewController: UITableViewController {

    var allQandAs = [CKRecord]() { didSet { tableView.reloadData() } }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllQandAs()
    }
    
    private let database = CKContainer.defaultContainer().publicCloudDatabase
    
    private func fetchAllQandAs() {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: Cloud.Entity.QandA, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: Cloud.Attribute.Question, ascending: true)]
        database.performQuery(query, inZoneWithID: nil) { (records, error) in
            if records != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.allQandAs = records!
                }
            }
        }
    }
    
    // MARK: UITableVIewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQandAs.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell tableView.dequeRu
    }
}
