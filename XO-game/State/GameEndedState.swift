//
//  GameEndedState.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class GameEndedState: GameState {
    
    // MARK: - Properties
    
    var isCompleted: Bool = false
    let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    
    // MARK: - Constuction
    
    init(winner: Player, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    // MARK: - Public functions
    
    func begin() {
        log(.gameFinished(winner: winner))
        
        gameViewController?.winnerLabel.isHidden = false
        
        if let winner = winner {
            gameViewController?.winnerLabel.text = winnerName(from: winner)
        } else {
            gameViewController?.winnerLabel.text = "No winner"
        }
        
        gameViewController?.secondPlayerTurnLabel.isHidden = true
        gameViewController?.firstPlayerTurnLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) { }
    
    // MARK: - Private functions
    
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first:
            return "1st player"
        case .second:
            return "2nd player"
        }
    }
    
}
