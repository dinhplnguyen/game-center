//
//  GuessCount.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct GuessCount: View {
    
    @StateObject public var hangmanVariables : GlobalString
    
    var body: some View {
        HStack {
            Text("Guesses Left: \(hangmanVariables.guessCount)")
                .font(.system(size: 15))
            // display score you get
            Text("Score: \(hangmanVariables.ScoreSystem[hangmanVariables.guessCount] ?? 0)")
                .font(.system(size: 15))
        }
//         Text("Guesses: \(hangmanVariables.guessCount)")
//             .font(.system(size: 25))
    }
}

struct GuessCount_Previews: PreviewProvider {
    static var previews: some View {
        GuessCount(hangmanVariables : GlobalString())
    }
}
