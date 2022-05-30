//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Yacine  Bentayeb on 30.05.22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var IsGameboardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var gameDifficulty: String = "Medium"
    
    func processPlayerMove (for i:Int) {
        
            // human make a move
            if isSquareOccupied(moves: moves, forIndex: i) { return }
            moves[i] = Move(player: .human, BoardIndex: i)
            
            
            // gameboard disabled until the computer makes a move
            IsGameboardDisabled = true
            
            // check human win or draw
            if winCheck(for: .human, in: moves) {
                alertItem = AlertContext.humanWin
                IsGameboardDisabled = false
                return
            }
            if drawCheck(moves: moves){
                alertItem = AlertContext.Draw
                IsGameboardDisabled = false
                return
            }
            
            // computer move after waiting 0.4 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){ [self] in
                let computerPos = computerMoveAI(moves: moves)
                if (computerPos != -1){
                    moves[computerPos] = Move(player: .computer, BoardIndex: computerPos)
                    IsGameboardDisabled = false
                    // check if computer win or draw
                    if winCheck(for: .computer, in: moves) {
                        alertItem = AlertContext.computerWin
                        return
                    }
                    if drawCheck(moves: moves){
                        alertItem = AlertContext.Draw
                        return
                    }
                }
            }
    }
    
    func isSquareOccupied(moves: [Move?], forIndex index: Int)-> Bool{
        if moves[index] != nil {
            return true
        } else {
            return false
        }
    }
    
    func computerMoveAI(moves: [Move?]) -> Int{
        
        let winPatterns: Set<Set<Int>> = [[0,1,2],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6],[3,4,5]]
        let ComputerMoves = moves.compactMap{ $0 }.filter{$0.player == .computer}
        let ComputerMovesPos = Set(ComputerMoves.map {$0.BoardIndex})
        let HumanMoves = moves.compactMap{ $0 }.filter{$0.player == .human}
        let HumanMovesPos = Set(HumanMoves.map {$0.BoardIndex})
        var IndexAvailable: Set<Int> = []
        
        // check the available moves
        for i in 0..<moves.count {
            if moves[i] == nil {
                IndexAvailable.insert(i)
            }
        }
        
        // If the computer can win return the index
        if gameDifficulty != "Easy"{
            for pattern in winPatterns {
                let winPosition = pattern.subtracting(ComputerMovesPos)
                if winPosition.count == 1 {
                    if winPosition.isSubset(of: IndexAvailable){
                        return (winPosition.first!)
                    }
                }
            }
        }
        
        //if the Human can win, block it
        if gameDifficulty != "Hard"{
            for pattern in winPatterns {
                let winPosition = pattern.subtracting(HumanMovesPos)
                if winPosition.count == 1 {
                    if winPosition.isSubset(of: IndexAvailable){
                        print(winPosition.first!)
                        return (winPosition.first!)
                    }
                }
            }
        }
        
        //if can't win and can't block, take the middle square
        if IndexAvailable.contains(4) && gameDifficulty != "Easy"{
            return 4
        }
        
        //select a random position
        if IndexAvailable.isEmpty == false{
            let movePosition = IndexAvailable.randomElement()!
            return movePosition
        }
        return -1 //if no more space to make a move
    }

    func winCheck(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6],[3,4,5]]
        let playerMoves = moves.compactMap{ $0 }.filter{$0.player == player}
        let PlayerMvPos = Set(playerMoves.map {$0.BoardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: PlayerMvPos){
            return true
        }
        return false
    }
    
    func drawCheck(moves: [Move?])-> Bool{
        var count = 0
        for index in 0..<moves.count{
            if isSquareOccupied(moves: moves, forIndex: index) {count += 1}
        }
        if count == 9 {
            return true
        }
        return false
    }
    
    func resetGame (){
        moves = Array(repeating: nil, count: 9)
    }
    
    func chooseDifficulty(difficulty: String){
        gameDifficulty = difficulty
    }
}
