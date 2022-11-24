//
//  XOButton.swift
//  gameCenter
//
//  Created by Arno Pan on 2022-10-13.
//

import SwiftUI

struct XOButton: View {
    @Binding var letter: String
    @State private var degree = 0.0
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            Text(letter)
                .font(.system(size: 50))
                .bold()
        }
        .rotation3DEffect(.degrees(degree), axis:(x:0,y:1,z:0))
        .simultaneousGesture(TapGesture()
            .onEnded{
                _ in withAnimation(.easeIn(duration: 0.25)){
                    self.degree -= 180
                }
            })
    }
}

struct XOButton_Previews: PreviewProvider {
    static var previews: some View {
        XOButton(letter: .constant("X"))
    }
}
