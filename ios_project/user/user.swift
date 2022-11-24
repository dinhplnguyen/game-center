//
//  user.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User : Encodable, Identifiable {
    var id: String
    
    let email: String
    var score: Int
}

