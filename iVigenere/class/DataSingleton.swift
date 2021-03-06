//
//  AppSingleton.swift
//  Vigenere
//
//  Created by Vincent PUGET on 20/08/2014.
//  Copyright (c) 2014 JPM & Associes. All rights reserved.
//

import UIKit
import CoreData

class DataSingleton: NSObject
{
  
  class var instance : DataSingleton
  {
    struct Static
    {
      static let instance : DataSingleton = DataSingleton()
    }
    
    return Static.instance
  }
  
  func dropAllMatrix()
  {
    let fetchRequestMatrix = NSFetchRequest<NSFetchRequestResult>(entityName: "Matrix")
    if let fetchResultMatrix = (try? self.managedObjectContext!.fetch(fetchRequestMatrix)) as? [Matrix]
    {
      for data:AnyObject in fetchResultMatrix
      {
        self.managedObjectContext!.delete(data as! Matrix)
      }
    }
    
    var error: NSError?
    
    do {
      try self.managedObjectContext!.save()
    } catch let error1 as NSError {
      error = error1
    }
    
    if let err = error
    {
      L.v(err.localizedFailureReason as AnyObject!);
    }
    else
    {
      L.v("DROP Matrix OK" as AnyObject!)
    }
  }
  
  func createDefaultMatrix() -> Bool
  {
    return DataSingleton.instance.saveNewMatrix("Matrice1", matrix: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@&é\"'(§è!çà)-_°0987654321#$ù%=+:/;.,?\\âêûîôäëüïöÂÊÛÎÔÄËÜÏÖ£`’ €÷*|~⇒…{}[]")
  }
  
  func setDefaultMatrix(_ matrixObj:Matrix!) -> Bool
  {
    return DataSingleton.instance.saveThisMatrix(matrixObj, name: matrixObj.name, matrix: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@&é\"'(§è!çà)-_°0987654321#$ù%=+:/;.,?\\âêûîôäëüïöÂÊÛÎÔÄËÜÏÖ£`’ €÷*|~⇒…{}[]")
  }
  
  func getMatrixObject() -> Matrix?
  {
    var matrix:Matrix?;
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Matrix")
    
    if let fetchResults = (try? self.managedObjectContext!.fetch(fetchRequest)) as? [Matrix]
    {
      if(fetchResults.count > 0)
      {
        matrix = fetchResults[0];
      }
    }
    return matrix;
  }
  
  func saveNewMatrix(_ name:String! , matrix:String!) -> Bool
  {
    var result:Bool! = false;
    
    let newMatrixObj:Matrix! = NSEntityDescription.insertNewObject(forEntityName: "Matrix", into: self.managedObjectContext!) as! Matrix
    newMatrixObj.name = name;
    newMatrixObj.matrix = matrix;
    
    var error: NSError?
    
    do {
      try self.managedObjectContext!.save()
    } catch let error1 as NSError {
      error = error1
    }
    
    if let err = error
    {
      L.v(err.localizedFailureReason as AnyObject!);
    }
    else
    {
      L.v("Save new matrix OK" as AnyObject!)
      
      result = true;
    }
    
    return result
  }
  
  func saveThisMatrix(_ matrixObj:Matrix! , name:String! , matrix:String!) -> Bool
  {
    var result:Bool! = false;
    
    matrixObj.name = name;
    matrixObj.matrix = matrix;
    
    var error: NSError?
    
    do {
      try self.managedObjectContext!.save()
    } catch let error1 as NSError {
      error = error1
    }
    
    if let err = error
    {
      L.v(err.localizedFailureReason as AnyObject!);
    }
    else
    {
      L.v("Save this matrix OK" as AnyObject!)
      
      result = true;
    }
    
    return result
  }

  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "mao.ios.iVigenere" in the application's documents Application Support directory.
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = Bundle.main.url(forResource: "iVigenere", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext!.hasChanges {
      do {
        try managedObjectContext!.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
  
}
