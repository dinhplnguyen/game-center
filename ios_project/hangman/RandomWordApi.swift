//
//  RandomWordApi.swift
//  ios_project
//
//  Created by Dinh Phi Long Nguyen on 2022-11-03.
//

import Foundation

struct Word: Codable {
    var word: String
}

struct Definition : Codable {
    var word: String
    var definition: String
}

class WordAPI : ObservableObject{
    func loadData(completion:@escaping (Word) -> ()) {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/randomword") else {
            print("Invalid url...")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let git = try! JSONDecoder().decode(Word.self, from: data!)
            print(git)
            DispatchQueue.main.async {
                completion(git)
            }
        }.resume()
        
    }
}

class DefinitionAPI : ObservableObject {
    
    func loadData(completion:@escaping (Definition) -> (), word: String) {

        guard let url = URL(string: "https://api.api-ninjas.com/v1/dictionary?word=" + word) else {
            print("Invalid url...")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("c5tMEeOGL8x3cWiEBz6zqw==mwNwnmjX6DRyRpJS", forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(url)
            let git = try! JSONDecoder().decode(Definition.self, from: data!)
            
            print(git)
            DispatchQueue.main.async {
                completion(git)
            }
        }.resume()
        
    }
}

//class WordAPI : ObservableObject {
//
//    let url = URL(string: "https://api.api-ninjas.com/v1/randomword")!
//
//    func loadData(completion:@escaping (Word) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            let word = try! JSONDecoder().decode(Word.self, from: data!)
//            print(word)
//            DispatchQueue.main.async {
//                completion(word)
//            }
//        })
//    }
//}


