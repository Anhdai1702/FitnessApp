//
//  File.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 7/3/25.
//

import Foundation

extension String {
    func validateEmailOrPhone() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let phoneRegex = "^(\\+?[1-9][0-9]{7,14})$"

        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        let isPhoneValid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)

        return isEmailValid || isPhoneValid
    }
}
