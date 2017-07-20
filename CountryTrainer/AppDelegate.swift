//
//  AppDelegate.swift
//  CountryTrainer
//
//  Created by Ben Sullivan on 11/08/2016.
//  Copyright © 2016 Ben Sullivan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let appDependencies = AppDependencies()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
    appDependencies.installRootVC(window: window!)

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var applicationDocumentsDirectory: URL = {
      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls[urls.count-1]
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
      let modelURL = Bundle.main.url(forResource: "CountryTrainer", withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {


    let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
          let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")

    let options = [
      NSMigratePersistentStoresAutomaticallyOption : Int(true),
      NSInferMappingModelAutomaticallyOption : Int(true)
    ]
    
    do {
      
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
      
    } catch {
      
      print(error)
    }
    
    return coordinator
    
  }()

  lazy var managedObjectContext: NSManagedObjectContext = {
    
    let coordinator = self.persistentStoreCoordinator
      var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = coordinator
      return managedObjectContext
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      if managedObjectContext.hasChanges {
          do {
              try managedObjectContext.save()
          } catch {
              let nserror = error as NSError
              NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
              abort()
          }
      }
  }

}

let ad = UIApplication.shared.delegate as! AppDelegate

