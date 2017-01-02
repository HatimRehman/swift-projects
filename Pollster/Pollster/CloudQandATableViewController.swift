//
//  CloudQandATableViewController.swift
//  Pollster
//
//  Created by Hatim Rehman on 2016-07-25.
//  Copyright © 2016 Hatim. All rights reserved.
//

import UIKit
import CloudKit

class CloudQandATableViewController: QandATableViewController {
    
    var ckQandARecord: CKRecord {
        get {
            if _ckQandARecord == nil {
                _ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
            }
            return _ckQandARecord!
        }
        set {
            _ckQandARecord = newValue
        }
    }
        
    private var _ckQandARecord: CKRecord? {
        didSet {
            let question = ckQandARecord[Cloud.Attribute.Question] as? String ?? ""
            let answers = ckQandARecord[Cloud.Attribute.Answers] as? [String] ?? []
            qanda = QandA(question: question, answers: answers)
            
            asking = ckQandARecord.wasCreatedByThisUser
        }
    }
    
    private let database = CKContainer.defaultContainer().publicCloudDatabase
    
    @objc private func iCloudUpdate() {
        if !qanda.question.isEmpty && !qanda.answers.isEmpty {
            ckQandARecord[Cloud.Attribute.Question] = qanda.question
            ckQandARecord[Cloud.Attribute.Answers] = qanda.answers
            iCloudSaveRecord(ckQandARecord)
        }
    }
    
    private func iCloudSaveRecord(recordToSave: CKRecord) {
        
        database.saveRecord(recordToSave) { (savedRecord, error) in
            if error?.code == CKErrorCode.ServerRecordChanged.rawValue {
                // ignore
            } else if error != nil {
                self.retryAfterError(error, withSelector: #selector(self.iCloudUpdate))
            }
        }
    }
    
    private func retryAfterError(error: NSError?, withSelector selector: Selector){
        
        dispatch_async(dispatch_get_main_queue()) {
            if let retryInterval = error?.userInfo[CKErrorRetryAfterKey] as? NSTimeInterval {
                NSTimer.scheduledTimerWithTimeInterval(
                    retryInterval,
                    target: self,
                    selector: selector,
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    override func textViewDidEndEditing(textView: UITextView) {
        super.textViewDidEndEditing(textView)
        iCloudUpdate()
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
        }
    
  }


