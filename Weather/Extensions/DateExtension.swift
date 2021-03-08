//
//  DateExtension.swift
//  Weather
//
//  Created by Макс Пайдич on 08.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

extension Date {
    func convertDate(with dateFormat: String, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
