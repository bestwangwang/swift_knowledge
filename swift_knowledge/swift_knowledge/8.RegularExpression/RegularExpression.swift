//
//  RegularExpression.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/12.
//

import Foundation
import SwiftUI

class RegularExpression {


    func action() {
        do {
        // e.g., "Spartan SportWHR 016411300074".
            // e.g., "Ambit3V #P1539195", # is excluded from the serial.
            let localName = "Ambit3V #P1539195"
            let expression = try NSRegularExpression(pattern: "^(.+)\\s+[#]?([P]?[A-Z0-9]+)$", options: [])
            // 去除头尾空格
            let trimmedLocalName = localName.trimmingCharacters(in: CharacterSet.whitespaces)
            if let match = expression.firstMatch( in: trimmedLocalName, options: [], range: NSRange(location: 0, length: trimmedLocalName.utf16.count)),
               let range1 = Range(match.range(at: 1), in: trimmedLocalName),
               let range2 = Range(match.range(at: 2), in: trimmedLocalName)
            {
                let name = String(trimmedLocalName[range1])
                let identifier = String(trimmedLocalName[range2])

                print(name)
                print(identifier)
            }
        } catch {

        }
    }
}
