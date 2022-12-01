//
//  PrimaryButton.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-24.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var body: some View {
        Text(text)
            .padding()
            .cornerRadius(30)
            .shadow(radius: 30)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Next")
    }
}
