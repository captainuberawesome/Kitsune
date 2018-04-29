//
//  RealmWrapper.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import RealmSwift

enum RealmWrapperEntityNotification<Type: TransientEntity> {
  case change(Type?)
  case deleted
}

class RealmWrapperNotificationToken {
  var realmToken: NotificationToken?
  
  init(token: NotificationToken?) {
    self.realmToken = token
  }
  
  func stop() {
    realmToken?.invalidate()
  }
}

// MARK: - Types

protocol RealmEntity {
  associatedtype TransientType: TransientEntity where TransientType.RealmType == Self
  
  static func from(transient: TransientType, in realm: Realm) -> Self
  func transient() -> TransientType
}

protocol TransientEntity {
  associatedtype RealmType: RealmEntity where RealmType.TransientType == Self
}

typealias VoidBlock = (() -> Void)
typealias RealmBlock = ((Realm) -> Void)

final class RealmWrapper: NSObject {
  
  // MARK: - Properties
  
  let inMemoryRealm: Realm
  
  // MARK: - Init
  
  override init() {
    inMemoryRealm = Realm.inMemoryStore()
  }
  
  // MARK: - Internal
  
  func clearInMemory(completion: VoidBlock? = nil) {
    writeAsync(copyToPersistent: false, completion: completion) { (realm) in
      realm.deleteAll()
    }
  }
  
  func clearAll(completion: VoidBlock? = nil) {
    writeAsync(copyToPersistent: true, completion: completion) { (realm) in
      realm.deleteAll()
    }
  }
  
  func overwriteInMemoryDataWithPersistent(completion: VoidBlock? = nil) {
    clearInMemory {
      DispatchQueue.global(qos: .utility).async {
        
        let persistent = Realm.persistentStore()
        let types: [Object.Type] = []
        
        self.writeSync(copyToPersistent: false) { (realm) in
          for type in types {
            let objects = persistent.objects(type)
            for object in objects {
              realm.create(type, value: object, update: true)
            }
          }
        }
        
        DispatchQueue.main.async {
          self.inMemoryRealm.refresh()
          completion?()
        }
      }
    }
  }
  
  func writeAsync(copyToPersistent: Bool = false, completion: VoidBlock? = nil,
                  writeBlock: @escaping RealmBlock) {
    DispatchQueue.global(qos: .utility).async {
      self.writeSync(copyToPersistent: copyToPersistent, block: writeBlock)
      DispatchQueue.main.async {
        self.inMemoryRealm.refresh()
        completion?()
      }
    }
  }
  
  // MARK: Private
  
  private func writeSync(copyToPersistent: Bool, block: @escaping RealmBlock) {
    do {
      let inMemory = Realm.inMemoryStore()
      try inMemory.write {
        block(inMemory)
      }
      if copyToPersistent {
        let persistent = Realm.persistentStore()
        try persistent.write {
          block(persistent)
        }
      }
    } catch let error {
      fatalError("Can't write to Realm instance: \(error)")
    }
  }
  
}
