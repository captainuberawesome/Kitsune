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

  enum StoreType {
    case persistent, inMemory
  }
  
  // MARK: - Properties
  
  private let storeType: StoreType
  private let inMemoryStoreIdentifier: String
  let realm: Realm
  
  // MARK: - Init
  
  init(storeType: StoreType = .persistent, inMemoryIdentifier: String = Constants.realmInMemoryStoreIdentifier) {
    self.storeType = storeType
    self.inMemoryStoreIdentifier = inMemoryIdentifier
    realm = RealmService.createRealmStore(storeType: storeType, inMemoryIdentifier: inMemoryIdentifier)
    super.init()
  }
  
  // MARK: - Private
  
  private static func createRealmStore(storeType: StoreType, inMemoryIdentifier: String) -> Realm {
    switch storeType {
    case .persistent:
      return Realm.persistentStore()
    case .inMemory:
      return Realm.inMemoryStore(inMemoryIdentifier: inMemoryIdentifier)
    }
  }
  
  // MARK: - Public
  
  func clear(completion: VoidBlock? = nil) {
    writeAsync(writeBlock: { realm in
      realm.deleteAll()
    }, completion: completion)
  }
  
  func writeAsync(writeBlock: @escaping RealmBlock, completion: VoidBlock? = nil) {
    DispatchQueue.global().async {
      self.writeSync(block: writeBlock)
      DispatchQueue.main.async {
        completion?()
      }
    }
  }
  
  // MARK: Private
  
  private func writeSync(block: @escaping RealmBlock) {
    do {
      let realm = RealmService.createRealmStore(storeType: storeType, inMemoryIdentifier: inMemoryStoreIdentifier)
      try realm.write {
        block(realm)
      }
    } catch let error {
      fatalError("Can't write to Realm instance: \(error)")
    }
  }
}
