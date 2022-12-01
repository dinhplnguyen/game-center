//
//  QuestionView.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-25.
//

import SwiftUI

struct QuestionView: View {
    
    @EnvironmentObject var triviaManager : TriviaManager
    
    @StateObject public var variable : GlobalString
    
    var body: some View {
        VStack(spacing: 40) {
            HStack{
                Text("Trivia Game")
                HStack {
                    Spacer()
                    Text("Your Score: \(variable.userScore)")
                        .padding(15)
                }
                Spacer()
                Text("\(triviaManager.index + 1) out of \(triviaManager.length)")
                
            }
            
            ProgressBar(progress: triviaManager.progress)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(triviaManager.question)
                    
                    .bold()
                
                ForEach(triviaManager.answerChoices, id: \.id) {
                    answer in AnswerRow(answer: answer)
                        .environmentObject(triviaManager)
                }
            }
            
            Button {
                triviaManager.goToNextQuestion()
                
            } label: {
                PrimaryButton(text: "Next")

            }.disabled(!triviaManager.answerSelected)
            Spacer()
        }
        .padding() }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(variable: GlobalString()).environmentObject(TriviaManager())
    }
}
