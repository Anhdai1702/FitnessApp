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
    static let isVietnamesChecked = "IsVietnamesChecked"
    static let isEnglishChecked = "IsEnglishChecked"
    static let didLanguageSetupKey = "DidLanguageSetupKey"
    static let loggedInUserIdKey = "LoggedInUserIdKey"
    static let noFirstLoginKey = "NoFirstLoginKey"
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
    var didLanguageSetup: Bool { get set }
    var isVietnamesChecked: Bool { get set }
    var isEnglishChecked: Bool { get set }
    var loggedInUserIdKey: Bool { get set }
    var noFirstLoginKey: Bool { get set }
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
    
  var noFirstLoginKey: Bool {
    get {
      return defaults.bool(forKey: DefaultsStorageKeys.noFirstLoginKey)
    }
      set {
        defaults.set(newValue, forKey: DefaultsStorageKeys.noFirstLoginKey)
    }
  }
    
  var loggedInUserIdKey: Bool {
      get {
          return defaults.bool(forKey: DefaultsStorageKeys.loggedInUserIdKey)
      }
      set {
          defaults.set(newValue, forKey: DefaultsStorageKeys.loggedInUserIdKey)
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
    
    var isVietnamesChecked: Bool {
        get {
            return defaults.bool(forKey: DefaultsStorageKeys.isVietnamesChecked)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.isVietnamesChecked)
        }
    }
    
    var isEnglishChecked: Bool {
        get {
            return defaults.bool(forKey: DefaultsStorageKeys.isEnglishChecked)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.isEnglishChecked)
        }
    }
    
    var didLanguageSetup: Bool {
      get {
        return defaults.bool(forKey: DefaultsStorageKeys.didLanguageSetupKey)
      }
      
      set {
        defaults.set(newValue, forKey: DefaultsStorageKeys.didLanguageSetupKey)
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
