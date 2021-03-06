//
//  ProfileCellViewModel.swift
//  Kitsune
//
//  Created by Daria Novodon on 24/05/2018.
//

import Foundation

func == (lhs: ProfileCellViewModel, rhs: ProfileCellViewModel) -> Bool {
  return lhs.cellReuseIdentifier == rhs.cellReuseIdentifier && lhs.infoType == rhs.infoType && lhs.value == rhs.value
}

class ProfileCellViewModel: Equatable {
  enum InfoType {
    case gender, location, birthday, joinDate
  }
  
  let cellReuseIdentifier: String
  let infoType: InfoType
  let value: String?
  
  init(infoType: InfoType, value: String?, cellReuseIdentifier: String) {
    self.infoType = infoType
    self.value = value
    self.cellReuseIdentifier = cellReuseIdentifier
  }
}
