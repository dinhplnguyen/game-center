//
//  Utils.swift
//  gameCenter
//
//  Created by Arno Pan on 2022-10-13.
//

import Foundation

func checkWinner(list: [String], letter: String) -> Bool {
    let winningSequence = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal wins
        [0, 4, 8], [2, 4, 6], // diagonal wins
        [0, 3, 6], [1, 4, 7], [2, 5, 8] // vertical wins
    ]
    
    for sequence in winningSequence{
        var score = 0
        
        for match in sequence{
            if list[match] == letter {
                score += 1
                
                if score == 3{
                    return true
                }
            }
        }
    }
    return false
}
