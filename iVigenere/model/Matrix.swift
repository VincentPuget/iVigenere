//
//  Const.swift
//  Vigenere
//
//  Created by Vincent PUGET on 24/02/2015.
//  Copyright (c) 2015 JPM & Associes. All rights reserved.
//

import Foundation
import CoreData

@objc(Matrix)

class Matrix: NSManagedObject {

    @NSManaged var matrix: String
    @NSManaged var name: String

}
