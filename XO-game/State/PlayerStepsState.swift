//
//  PlayerStepsState.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class PlayerStepsState: GameState {
    
    // MARK: - Properties
    
    let markViewPrototype: MarkView
    
    let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private(set) weak var stepInvoker: StepInvoker?
    
    var isCompleted: Bool = false
    
    // MARK: - Construction
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    // MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second, .computer:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        log(.playerInput(play: player, position: position))
        guard
            let gameboardView = gameboardView,
            let gameboard = gameboard
        else { return }
        
        let command = StepCommand(
            position: position,
            player: player,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: markViewPrototype
        )
        gameViewController?.stepInvoker?.addCommand(command)
        isCompleted = true
    }
    
    func addRandomMark() {
        guard
            let gameboardView = gameboardView,
            let gameboard = gameboard,
            let index = gameViewController?.stepInvoker?.commandsCount()
        else { return }
        
        let position = gameboardView.allPositions[index % gameboardView.allPositions.count]
        let command = StepCommand(
            position: position,
            player: player,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: markViewPrototype
        )
        gameViewController?.stepInvoker?.addCommand(command)

        isCompleted = true
    }
}
