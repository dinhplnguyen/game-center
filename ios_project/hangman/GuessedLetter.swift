//
//  GuessedWord.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct GuessedLetter: View {
    
    @StateObject public var hangmanVariables : GlobalString
    
    var body: some View {
        Text("Guessed Letters")
        HStack {
            ForEach(hangmanVariables.guessedWord, id: \.self) { d in
                if !hangmanVariables.wordToGuess.contains(d){ // don't display correct letter
                    Text(d)
                }
            }
        }.font(.system(size: 20))
            .padding(.bottom, 50)
    }
}

struct GuessedLetter_Previews: PreviewProvider {
    static var previews: some View {
        GuessedLetter(hangmanVariables :GlobalString())
    }
}
