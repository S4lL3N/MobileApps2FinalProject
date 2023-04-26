//
//  GameViewModel.swift
//  TickTacToe
//
//  Created by user236029 on 4/25/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func isSet(in moves: [Move?], forindex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    func processMove(for i: Int){
        //human move
        if isSet(in: moves, forindex: i){return}
        moves[i] = Move(player: .human, boardIndex: i)
        
        if checkForWin(for: .human, in: moves){
            //print("human wins")
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves){
            //print("Draw")
            alertItem = AlertContext.draw
            return
        }
        isBoardDisabled = true
        
        //computer move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPOS = findComputerMove(in: moves)
            moves[computerPOS] = Move(player: .computer, boardIndex: computerPOS)
            isBoardDisabled = false
            if checkForWin(for: .computer, in: moves){
                //print("computer wins")
                alertItem = AlertContext.ComputerWin
                return
            }
            if checkForDraw(in: moves){
                //print("Draw")
                alertItem = AlertContext.draw
                return
            }
            
            
        }
    }
    func findComputerMove(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        // go for win
        let computerMoves = moves.compactMap{$0}.filter{$0.player == .computer}
        let computerPOSs = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPOSs)
            if winPositions.count == 1 {
                let isAvaliable = !isSet(in: moves, forindex: winPositions.first!)
                if isAvaliable{return winPositions.first!}
            }
        }
        
        //block moves
        let humanMoves = moves.compactMap{$0}.filter{$0.player == .human}
        let humanPOSs = Set(humanMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPOSs)
            if winPositions.count == 1 {
                let isAvaliable = !isSet(in: moves, forindex: winPositions.first!)
                if isAvaliable{return winPositions.first!}
            }
        }
        
        //take middle square
        let center = 4
        if !isSet(in: moves, forindex: center){return center}
        
        //choose random
        var movePOS = Int.random(in: 0..<9)
        while isSet(in: moves, forindex: movePOS){
            movePOS = Int.random(in: 0..<9)
        }
        return movePOS
    }
    
    func checkForWin(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPOS = Set(playerMoves.map{$0.boardIndex})
        for pattern in winPatterns {
            if pattern.isSubset(of: playerPOS) {
                return true
            }
        }
        return false
    }
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{$0}.count == 9
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
}
