//
//  Matrix+CoreDataProperties.swift
//  iVigenere
//
//  Created by Vincent PUGET on 22/04/2016.
//  Copyright © 2016 Vincent PUGET. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

@objc(Matrix)

class Matrix: NSManagedObject {
  
  @NSManaged var matrix: String
  @NSManaged var name: String
  
}
