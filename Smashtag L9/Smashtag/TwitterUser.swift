//
//  TwitterUser.swift
//  Smashtag
//
//  Created by Hatim Rehman on 2016-06-22.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class TwitterUser: NSManagedObject {

    class func twitterUserWithTwitterInfo(twitterInfo: Twitter.User, inManagedObjectContext context: NSManagedObjectContext) -> TwitterUser? {
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "unique %a", twitterInfo.id)
        
        if let twitterUser = (try? context.executeFetchRequest(request))?.first as? TwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
            
        }
        
        return nil
    }

}
