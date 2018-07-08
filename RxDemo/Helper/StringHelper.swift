//
//  StringHelper.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let regexStatement = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexStatement)
        return predicate.evaluate(with: self) && !self.contains("..")
    }
}
