//
//  String+Extension.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation

extension String {
  func validateEmail() -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: self)
  }
  func validatePassword() -> Bool {
    let passwordRegex = "^[a-zA-Z0-9!@#$%^&*()_+=?]{8,15}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return predicate.evaluate(with: self)
  }
}
