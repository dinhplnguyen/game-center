//
//  Answer.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-25.
//

import Foundation

struct Answer: Identifiable {
    var id = UUID()
    var text: AttributedString
    var isCorrect: Bool
}
