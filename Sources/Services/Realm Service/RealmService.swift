//
//  RealmService.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import RealmSwift

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

final class RealmService: NSObject {
  
  // MARK: - Properties
  
  let persistentRealm: Realm
  
  // MARK: - Init
  
  override init() {
    persistentRealm = Realm.persistentStore()
  }
  
  // MARK: - Public
  
  func clear(completion: VoidBlock? = nil) {
    writeAsync(writeBlock: { realm in
      realm.deleteAll()
    }, completion: completion)
  }
  
  func writeAsync(writeBlock: @escaping RealmBlock, completion: VoidBlock? = nil) {
    DispatchQueue.global(qos: .utility).async {
      self.writeSync(block: writeBlock)
      DispatchQueue.main.async {
        self.persistentRealm.refresh()
        completion?()
      }
    }
  }
  
  // MARK: Private
  
  private func writeSync(block: @escaping RealmBlock) {
    do {
      let persistentRealm = Realm.persistentStore()
      try persistentRealm.write {
        block(persistentRealm)
      }
    } catch let error {
      fatalError("Can't write to Realm instance: \(error)")
    }
  }
}
