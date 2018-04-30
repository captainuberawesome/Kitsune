//
//  RealmService+Generics.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import RealmSwift

extension RealmService {
  
  // MARK: Saving
  
  func save<Type: TransientEntity>(object: Type, completion: VoidBlock? = nil) where Type.RealmType: Object {
    writeAsync(writeBlock: { realm in
      let realmEntity = Type.RealmType.from(transient: object, in: realm) as Object
      realm.add(realmEntity, update: true)
    }, completion: completion)
  }
  
  func save<Type: TransientEntity>(objects: [Type], completion: VoidBlock? = nil) where Type.RealmType: Object {
    writeAsync(writeBlock: { realm in
      let realmEntities = objects.compactMap { Type.RealmType.from(transient: $0, in: realm) as Object }
      realm.add(realmEntities)
    }, completion: completion)
  }
  
  // MARK: Deleting
  
  func delete<Type: TransientEntity>(object: Type, completion: VoidBlock? = nil) where Type.RealmType: Object {
    
    writeAsync(writeBlock: { (realm) in
      let realmEntity = Type.RealmType.from(transient: object, in: realm) as Object
      if realmEntity.realm == realm {
        realm.delete(realmEntity)
      }
    }, completion: completion)
  }
}
