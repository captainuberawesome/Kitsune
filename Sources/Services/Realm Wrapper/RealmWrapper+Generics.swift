//
//  RealmWrapper+Generics.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import RealmSwift
import Foundation

extension RealmWrapper {
  
  // MARK: Saving
  
  func save<Type: TransientEntity>(object: Type, copyToPersistentStore: Bool = false, completion: VoidBlock? = nil)
    where Type.RealmType: Object {
    
    writeAsync(copyToPersistent: copyToPersistentStore, completion: completion) { (realm) in
      let realmEntity = Type.RealmType.from(transient: object, in: realm) as Object
      realm.add(realmEntity, update: true)
    }
  }
  
  func save<Type: TransientEntity>(objects: [Type], copyToPersistentStore: Bool = false, completion: VoidBlock? = nil)
    where Type.RealmType: Object {
    
    writeAsync(copyToPersistent: copyToPersistentStore, completion: completion) { (realm) in
      let realmEntities = objects.compactMap { Type.RealmType.from(transient: $0, in: realm) as Object }
      realm.add(realmEntities)
    }
  }
  
  // MARK: Deleting
  
  func delete<Type: TransientEntity>(object: Type, copyToPersistentStore: Bool = true, completion: VoidBlock? = nil)
    where Type.RealmType: Object {
    
    writeAsync(copyToPersistent: copyToPersistentStore, completion: completion) { (realm) in
      let realmEntity = Type.RealmType.from(transient: object, in: realm) as Object
      if realmEntity.realm == realm {
        realm.delete(realmEntity)
      }
    }
  }
  
  // MARK: Subscribing
  
  func subscribeTo<Type>(_ object: Type,
                         onChange: ((RealmWrapperEntityNotification<Type>) -> Void)?,
                         completion: ((RealmWrapperNotificationToken?) -> Void)? = nil)
    where Type.RealmType: Object {
      let backgroundQueue = DispatchQueue.global(qos: .utility)
      backgroundQueue.async {
        do {
          var realmBackgroundEntity: Object?
          let inMemoryRealmBackground = Realm.inMemoryStore()
          try inMemoryRealmBackground.write {
            realmBackgroundEntity = Type.RealmType.from(transient: object, in: inMemoryRealmBackground) as Object
          }
          guard let realmEntity = realmBackgroundEntity else {
            DispatchQueue.main.async {
              completion?(nil)
            }
            return
          }
          if realmEntity.realm != nil {
            self.subscribeToManagedEntity(realmEntity, onChange: onChange, completion: completion)
          } else {
            try inMemoryRealmBackground.write {
              inMemoryRealmBackground.add(realmEntity)
            }
            self.subscribeToManagedEntity(realmEntity, onChange: onChange, completion: completion)
          }
        } catch let error {
          log.error("Can't write to Realm instance: \(error)")
          DispatchQueue.main.async {
            completion?(nil)
          }
        }
     }
  }
  
  private func subscribeToManagedEntity<Type>(_ entity: Object,
                                              onChange: ((RealmWrapperEntityNotification<Type>) -> Void)?,
                                              completion: ((RealmWrapperNotificationToken?) -> Void)? = nil)
    where Type.RealmType: Object {
      
    let entityRef = ThreadSafeReference(to: entity)
    DispatchQueue.main.async {
      var token: NotificationToken? = nil
      let inMemoryRealm = Realm.inMemoryStore()
      guard let realmEntity = inMemoryRealm.resolve(entityRef) else {
        completion?(nil)
        return
      }
      token = realmEntity.observe { change in
        switch change {
        case .change:
          if let realmObject = realmEntity as? Type.RealmType {
            let entity = realmObject.transient()
            onChange?(.change(entity))
          }
        case .error(let error):
          log.error("An error occurred: \(error)")
        case .deleted:
          onChange?(.deleted)
        }
      }
      completion?(RealmWrapperNotificationToken(token: token))
    }
  }
  
}
