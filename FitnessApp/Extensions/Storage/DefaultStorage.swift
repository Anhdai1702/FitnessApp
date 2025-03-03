//
//  DefaultStorage.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 3/3/25.
//

import Foundation

private struct DefaultsStorageKeys {
  static let noFirstTimeLaunchKey = "noFirstTimeLaunchKey"
    static let currentLanguageKey = "CurrentLanguageKey"
}

protocol UserDefaultsProvider {
  func set(_ value: Any?, forKey defaultName: String)
  func bool(forKey defaultName: String) -> Bool
  func double(forKey defaultName: String) -> Double
  func integer(forKey defaultName: String) -> Int
  func string(forKey defaultName: String) -> String?
  func date(forKey defaultName: String) -> Date?
  func arrInterger(forKey defaultName: String) -> [Int]?
}

extension UserDefaults: UserDefaultsProvider {
  func date(forKey defaultName: String) -> Date? {
    guard let date = value(forKey: defaultName) as? Date  else { return nil }
    return date
  }
  
  func arrInterger(forKey defaultName: String) -> [Int]? {
    guard let arrInt = value(forKey: defaultName) as? [Int]  else { return nil }
    return arrInt
  }
}

protocol DefaultsStorage {
    
  var noFirstTimeLaunch: Bool { get set }
  var currentLanguage: String { get set }

}

class DefaultsStorageImpl: DefaultsStorage {
  
  // MARK: - Init
  
  init(userDefaultsProvider: UserDefaultsProvider = UserDefaults.standard) {
    defaults = userDefaultsProvider
  }
  
  // MARK: - Private Variables
  
  private let defaults: UserDefaultsProvider
  
  // MARK: - Public Variables
    
  
  var noFirstTimeLaunch: Bool {
    get {
      return defaults.bool(forKey: DefaultsStorageKeys.noFirstTimeLaunchKey)
    }
    
    set {
      defaults.set(newValue, forKey: DefaultsStorageKeys.noFirstTimeLaunchKey)
    }
  }
    
  var currentLanguage: String {
    get {
      return defaults.string(forKey: DefaultsStorageKeys.currentLanguageKey) ?? "en"
    }
      
    set {
      defaults.set(newValue, forKey: DefaultsStorageKeys.currentLanguageKey)
    }
  }
    
  private func getCurrencyBasedOnLanguage() -> String {
    switch currentLanguage {
    case "vi":
     return "VND"
    case "en":
     return "USD"
    // add case if needed
    default:
     return "USD"
    }
  }
  
}
