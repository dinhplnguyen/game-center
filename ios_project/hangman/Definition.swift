//
//  Defenition.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-22.
//

import SwiftUI

struct Definition_View: View {
    
    @StateObject public var hangmanVariables : GlobalString
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            if hangmanVariables.guessCount <= 2 {
                Text(hangmanVariables.definition)
                    .padding(20)
            }
        }
    }
}

struct Definition_Previews: PreviewProvider {
    static var previews: some View {
        Definition_View(hangmanVariables : GlobalString())
    }
}
