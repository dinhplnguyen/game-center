//
//  Keyboard.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Keyboard: View {
    @StateObject public var hangmanVariables : GlobalString
    
    @State private var firstLine: [String] = ["Q","W","E","R","T","Y","U","I","O","P"]
    @State private var secondLine: [String] = ["A","S","D","F","G","H","J","K","L"]
    @State private var thirdLine: [String] = ["Z","X","C","V","B","N","M"]
    
    func chooseChar(char : String) {
        // if buttonKey matched with letter of word to guess
        for (index, element) in hangmanVariables.wordToGuess.enumerated() {
            if char == String(element) {
                hangmanVariables.tempWords[index] = char // add to temp words
            }
        }
        
        // if the letter is (not already guessed) and (not matched with given word)
        if hangmanVariables.guessCount >= 1 && hangmanVariables.gameContinue {
            if !hangmanVariables.wordToGuess.contains(char) &&
                !hangmanVariables.guessedWord.contains(char){
                hangmanVariables.guessCount -= 1 // deduct num of guess
                hangmanVariables.guessedWord.append(char) // only add wrong letter to guessed list
            }
            
            // if not yet add to Guessed Words (for display wrong word in red when game ends)
            if !hangmanVariables.guessedWord.contains(char) {
                hangmanVariables.guessedWord.append(char)
            }
        }
    }
    
    func gameEnd() { // check game state: win, lose, guess left
        
        if hangmanVariables.guessCount <= 0 { // if there is no guess left
            hangmanVariables.gameContinue = false // stop the game
            
            // cast all final word letters to temporary to display later
            for (index, element) in hangmanVariables.wordToGuess.enumerated() {
                hangmanVariables.tempWords[index] = String(element)
            }
        } else { // if there is still guess (game will continues)
            if !hangmanVariables.tempWords.contains("_") { // if all letters correctly guessed
                hangmanVariables.win = true // you win
                hangmanVariables.gameContinue = false // stop the game

                // update user score
                let db = Firestore.firestore()
                let user = Auth.auth().currentUser
                if let user = user {
                    let docRef = db.collection("users").document(user.uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            print("Document data: \(dataDescription)")
                            let score = document.data()?["score"] as? Int ?? 0
                            let newScore = score + hangmanVariables.ScoreSystem[hangmanVariables.guessCount]!
                            docRef.updateData(["score": newScore])
                            hangmanVariables.userScore = newScore
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(firstLine, id: \.self) { word in
                    Button(word, action: {
                        chooseChar(char: word)
                        gameEnd()
                    })
                    
                }
            }
            
            HStack {
                ForEach(secondLine, id: \.self) { word in
                    Button(word, action: {
                        chooseChar(char: word)
                        gameEnd()
                    })
                }
            }
            
            HStack {
                ForEach(thirdLine, id: \.self) { word in
                    Button(word, action: {
                        chooseChar(char: word)
                        gameEnd()
                    })
                }
            }
        }.font(.system(size: 30))
            .padding(.bottom, 10)
        
        
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard(hangmanVariables: GlobalString())
    }
}
