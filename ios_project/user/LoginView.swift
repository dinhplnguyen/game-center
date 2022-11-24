//
//  LoginView.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LoginView: View {
    
    @State private var isLogin: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker("", selection: $isLogin) {
                    Text("Log In")
                        .tag(true)
                    Text("Create Account")
                        .tag(false)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280, height: 45, alignment: .center)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280, height: 45, alignment: .center)
                Spacer()
                Button(action: {
                    if isLogin {
                        loginUser()
                    } else {
                        createUser()
                    }
                }, label: {
                    Text(isLogin ? "Log In" : "Create Account")
                        .foregroundColor(.white)
                
                }).frame(width: 280, height: 45, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(8)

                // logout button
                Button(action: {
                    logoutUser()
                }, label: {
                    Text("Log Out")
                        .foregroundColor(.white)
                }).frame(width: 280, height: 45, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(8) 

            }.navigationTitle(isLogin ? "Welcome Back" : "Welcome")
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            print("Successfully logged in with ID: \(result?.user.uid ?? "")")
            
                    // lead user to Home tab view after login
        let tabView = ContentView()
        // use UIWindowScene.windows to get the current window
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        window?.rootViewController = UIHostingController(rootView: tabView)
        window?.makeKeyAndVisible()
            
        }

    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            print("Successfully created account with ID: \(result?.user.uid ?? "")")

            // add user to database
            let user = User(id: result!.user.uid, email: email, score: 0)
            do {
                try db.collection("users").document(result!.user.uid).setData(from: user)
            } catch {
                print("Error writing user to Firestore: \(error)")
            }
        })
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("Successfully logged out")
            if Auth.auth().currentUser == nil {
                print("No user is logged in")
            }
            let tabView = ContentView()
            // use UIWindowScene.windows to get the current window
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            window?.rootViewController = UIHostingController(rootView: tabView)
            window?.makeKeyAndVisible()
        } catch {
            print("Failed to log out")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
