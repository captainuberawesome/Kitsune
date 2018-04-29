//
//  Realm+Stores.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import RealmSwift

/*
 
 --------| Description for each schema version |--------
 
 0 - Default version
 
 ------------------------------------------------------------
 
 */

fileprivate extension Constants {
  static let currentRealmSchemaVersion: UInt64 = 0
}

extension Realm {
  
  class func inMemoryStore(inMemoryIdentifier: String = Constants.realmInMemoryStoreIdentifier) -> Realm {
    do {
      let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier))
      return realm
    } catch let error as NSError {
      fatalError("Error while creating Realm in-memory store: \(error)")
    }
  }
  
  class func persistentStore() -> Realm {
    do {
      var configuration = Realm.Configuration(
        schemaVersion: Constants.currentRealmSchemaVersion,
        migrationBlock: nil)
      configuration.deleteRealmIfMigrationNeeded = false
      let realm = try Realm(configuration: configuration)
      return realm
    } catch {
      fatalError("Error while creating Realm persistent store: \(error)")
    }
  }

}
