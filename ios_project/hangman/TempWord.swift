//
//  TempWord.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct TempWord: View {
    
    @StateObject public var hangmanVariables : GlobalString
    
    var body: some View {
        HStack {
            ForEach(hangmanVariables.tempWords, id: \.self) { d in
                if (!hangmanVariables.gameContinue && //display wrong letter (not rightly guessed) in red
                    !hangmanVariables.guessedWord.contains(d)) {
                    Text(d)
                        .foregroundColor(.red)
                } else if (hangmanVariables.win) {
                    Text(d).foregroundColor(.green)
                } else {
                    Text(d)
                }
                
            }
        }.font(.system(size: 30))
            .padding(30)
            .padding(.bottom, 15)
    }
}

struct TempWord_Previews: PreviewProvider {
    static var previews: some View {
        TempWord(hangmanVariables : GlobalString())
    }
}
