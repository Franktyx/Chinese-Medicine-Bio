//
//  Herb.swift
//  神农本草经
//
//  Created by Yuxiang Tang on 10/8/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import Foundation
import CoreData

class Herb: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var herbDescription: String
    
}
