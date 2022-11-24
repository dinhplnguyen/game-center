//
//  HangmanGame.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct HangmanGame: View {
    
    @StateObject public var hangmanVariables : GlobalString
    @State public var showingAlert : Bool
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                Spacer()
                Text("Your Score: \(hangmanVariables.userScore)")
                    .padding(15)
            }
            
            Header()
            
            GuessCount(hangmanVariables: hangmanVariables)
            
            Spacer()
            
            Definition_View(hangmanVariables: hangmanVariables)
            
            // Temporary guessed letter
            TempWord(hangmanVariables: hangmanVariables)
            
            // Keyboard
            Keyboard(hangmanVariables: hangmanVariables)
            
            // Letter that have guessed
            GuessedLetter(hangmanVariables: hangmanVariables)
            
            // Restart Button
            RestartButton(hangmanVariables: hangmanVariables,
                          showingAlert: showingAlert)
        }
        .navigationTitle("Hangman")
        .onAppear(perform: {
            hangmanVariables.newGame()
        })
    }
}

struct HangmanGame_Previews: PreviewProvider {
    static var previews: some View {
        HangmanGame(hangmanVariables : GlobalString(), showingAlert: false)
    }
}
