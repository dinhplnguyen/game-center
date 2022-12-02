//
//  TriviaView.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TriviaView: View {
    @EnvironmentObject var triviaManager : TriviaManager
    
    @StateObject public var variable : GlobalString
    
    var body: some View {
        ZStack {
            
            Color(red: 242/255, green: 225/255, blue: 207/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                if triviaManager.reachedEnd {
                    HStack {
                        Spacer()
                        Text("Your Score: \(variable.userScore)")
                            .padding(15)
                    }
                    
                    VStack(spacing: 20) {
                        
                        Text("Trivia Game End")
                        
                        Text("You have completed the game!")
                        
                        Text("You got \(triviaManager.score) out of \(triviaManager.length)")
                        
                        Text("You scored \(triviaManager.score*10)")
                        
                        Button {
                            Task.init {
                                await triviaManager.fetchTrivia()
                            }
                        } label: {
                            PrimaryButton(text: "Play Again")
                        }
                    }.padding()
                        .onAppear(perform: {
                            updateScore(newscore: triviaManager.score*10)
                            print("Score updated")
                        })
                } else {
                    QuestionView(variable: variable)
                        .environmentObject(triviaManager)
                }
            }
        }
    }
    
    func updateScore(newscore: Int) {
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
                    let newScore = score + newscore
                    docRef.updateData(["score": newScore])
                    variable.userScore = newScore
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView(variable: GlobalString())
            .environmentObject(TriviaManager()
            )
    }
}
