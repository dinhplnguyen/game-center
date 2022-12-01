//
//  AnswerRow.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-25.
//

import SwiftUI

struct AnswerRow: View {
    @EnvironmentObject var triviaManager : TriviaManager

    var answer: Answer
    @State private var isSelected = false
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "circle.fill")
                .font(.caption)
            
            Text(answer.text)
                .bold()
            
            if isSelected {
                Spacer()
                
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(answer.isCorrect ?
                        .green : .red)
            }
            
        }
        .foregroundColor( triviaManager.answerSelected ? (isSelected ? .blue : .gray) : .blue)
        .padding()
        .cornerRadius(10)
        .onTapGesture {
            if !triviaManager.answerSelected {
                isSelected = true
                triviaManager.selectAnswer(answer: answer)
            }
        }
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRow(answer: Answer(text: "Random Answer", isCorrect: false))
            .environmentObject(TriviaManager())
    }
}
