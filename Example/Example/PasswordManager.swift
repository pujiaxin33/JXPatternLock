//
//  PasswordManager.swift
//  Example
//
//  Created by jiaxin on 2019/6/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class PasswordManager {
    static func currentPassword() -> String? {
        return UserDefaults.standard.string(forKey: "kPatterLockPassowrd")
    }

    static func updatePassword(_ password: String?) {
        UserDefaults.standard.setValue(password, forKey: "kPatterLockPassowrd")
    }
}
