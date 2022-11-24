//
//  RestartButton.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct RestartButton: View {
    
    @StateObject public var hangmanVariables: GlobalString
    @State public var showingAlert : Bool
    
    var body: some View {
        Button("New Game", action: {
            showingAlert = true
        })
        
        .alert("Restart", isPresented: $showingAlert, actions: {
            Button("OK", role: .destructive, action: {
                hangmanVariables.newGame()
            })
        }, message: {
            Text("Guess new word")
        })
    }
}

struct RestartButton_Previews: PreviewProvider {
    static var previews: some View {
        RestartButton(hangmanVariables: GlobalString(), showingAlert: false)
    }
}
