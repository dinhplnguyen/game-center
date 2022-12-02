//
//  ContentView.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-10-11.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class GlobalString: ObservableObject {
    @Published var tempWords: [String] = [String]()
    @Published var wordToGuess: String = ""
    @Published var guessedWord: [String] = [String]()
    @Published var definition : String = ""

    @Published var ScoreSystem : [Int : Int] =
    [
        1 : 5,
        2 : 10,
        3 : 30,
        4 : 50,
        5 : 100,
    ]
    
    @Published var guessCount : Int = 5;
    @Published var gameContinue : Bool = true;
    @Published var win: Bool = false;

    @Published var userScore: Int = 0;
    @Published var userEmail: String = "";
    
    func newGame() {
        WordAPI().loadData(completion: { word in
            self.wordToGuess = word.word.uppercased()
            self.tempWords = [String]()
            for _ in self.wordToGuess {
                self.tempWords.append("_")
            }
            DefinitionAPI().loadData(completion: {def in
                self.definition = def.definition
            }, word: self.wordToGuess)
        })
        
        self.gameContinue = true
        self.win = false
        self.guessedWord = [String]()
        self.guessCount = 5

        fetchUserScoreAndEmail()
    }

    func fetchUserScoreAndEmail() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        // check if user is logged in
        if user == nil {
            print("User is not logged in")
        } else {
            print("User is logged in")
        }

        // get user email and scor
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let email = currentUser.email
            let uid = currentUser.uid
            self.userEmail = email!
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.userScore = document.data()?["score"] as? Int ?? 0
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject var globalString: GlobalString = GlobalString()
    @StateObject var triviaManager: TriviaManager = TriviaManager()
    
    @State private var moves: [String] = ["", "", "", "", "", "", "", "", ""]
    // there are 9 possible views
    @State private var endGameText: String = "TicTacToe"
    // when the game ends this is the message
    @State private var gameEnded: Bool = false
    // Boolean to see if the game has ended or not
    private var ranges: [Range<Int>] = [(0..<3), (3..<6), (6..<9)]
    // ranges 1 row 2 row 3 row
    
    var body: some View {
        
        TabView {
            NavigationView {
                ZStack {
                    Color(red: 242/255, green: 225/255, blue: 207/255).edgesIgnoringSafeArea(.all)
                    VStack (spacing:100) {
                            //Hang man
                            NavigationLink(destination: {
                                HangmanGame(hangmanVariables: globalString, showingAlert: false)

                            }){VStack{
                                Image(systemName: "h.square.fill").resizable().frame(width: 30, height: 30)
                                Text("Hangman").font(.system(size: 30))
                            }
                            }.padding(20).foregroundColor(.red).overlay(
                                RoundedRectangle(cornerRadius: 16)
                                .stroke(.indigo, lineWidth: 5)
                                .frame(width:200, height: 100)
                                .shadow(radius: 5, x: 5, y: 5))

                            // TicTacToe
                            NavigationLink(destination: {
                                ZStack {
                                    
                                        Color(red: 242/255, green: 225/255, blue: 207/255).edgesIgnoringSafeArea(.all)
                                    VStack{
                                        HStack {
                                            Spacer()
                                            Text("Your Score: \(globalString.userScore)")
                                                .padding(15)
                                        }
                                        Text(endGameText)
                                            .alert(endGameText, isPresented: $gameEnded){
                                                Button("Reset", role: .destructive, action: resetGame)
                                            }
                                        Spacer()
                                        // Grid
                                        ForEach(ranges, id: \.self){
                                            range in HStack{
                                                ForEach(range, id: \.self){
                                                    i in XOButton(letter: $moves[i])
                                                        .simultaneousGesture(
                                                            TapGesture()
                                                                .onEnded{
                                                                    _ in playerTap(index: i)
                                                                }
                                                        )
                                                }
                                            }
                                        }
                                        Spacer()
                                        // Grid
                                        Button("Reset", action: resetGame)
                                    }
                                }
                            }) {
                                VStack{
                                    Image(systemName: "t.circle.fill").resizable().frame(width: 30, height: 30)
                                    Text("TicTacToe").font(.system(size: 30))
                                }
                            }.padding(20).foregroundColor(.cyan).overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.indigo, lineWidth: 5)
                                    .frame(width:200, height: 100)
                                    .shadow(radius: 5, x: 5, y: 5))
                        
                            
                            // Trivia
                            NavigationLink(destination: {
                                TriviaView(variable: globalString)
                                    .environmentObject(triviaManager)

                            }){VStack{
                                Image(systemName: "t.square.fill").resizable().frame(width: 30, height: 30)
                                Text("Trivia").font(.system(size: 30))
                            }
                            }.padding(20).foregroundColor(.green).overlay(
                                RoundedRectangle(cornerRadius: 16)
                                        .stroke(.indigo, lineWidth: 5)
                                        .frame(width:200, height: 100)
                                        .shadow(radius: 5, x: 5, y: 5)
                            )
                            
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.indigo, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            
                                VStack {
                                    Text("Welcome To Game Center!").font(.headline)
                                    Text("hello, " + globalString.userEmail)
                                }.padding(20)
                            
                        }
                }
                }
            }
            .tabItem{
                Text("Game")
                Label("Order", systemImage: "gamecontroller")
            }
            
            ScoreBoard()
                .tabItem{
                    Text("Scoreboard")
                    Label("Order", systemImage: "flag.checkered.2.crossed")
                }
            
            LoginView()
                .tabItem{
                    Text("Profile")
                    Label("Order", systemImage: "person.circle")
                }
        }
        
        .onAppear(perform: {
            globalString.fetchUserScoreAndEmail()
        })
        
    }
    
    func playerTap(index: Int){
        if moves[index] == ""{
            moves[index] = "X"
            botMove()
        }
        
        for letter in ["X", "O"]{
            if checkWinner(list: moves, letter: letter){
                endGameText = "\(letter) has won!"
                gameEnded = true
                
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
                            let newScore = score + 30
                            docRef.updateData(["score": newScore])
                            globalString.userScore = newScore
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                break
            }
        }
    }
    
    func botMove(){
        var availableMoves: [Int] = []
        var movesLeft = 0
        
        for move in moves{
            if move == ""{
                availableMoves.append(movesLeft)
            }
            movesLeft += 1
        }
        
        if availableMoves.count != 0{
            moves[availableMoves.randomElement()!] = "0"
        }
    }
    
    func resetGame(){
        endGameText = "TicTacToe"
        moves = ["", "", "", "", "", "", "", "", ""]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




