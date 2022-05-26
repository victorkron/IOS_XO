//
//  StepCommand.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class StepCommand {
    
    private var player: Player
    private var position: GameboardPosition
    private var markViewPrototype: MarkView
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private var referee: Referee?
    
    
    init(position: GameboardPosition, player: Player, gameboard: Gameboard, gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.position = position
        self.player = player
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
        self.referee = Referee(gameboard: gameboard)
    }
    
    func execute() {
        guard
            let gameboardView = gameboardView,
            let gameboard = gameboard
        else { return }
        
        if gameboardView.canPlaceMarkView(at: position) {
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        } else {
            gameboardView.removeMarkView(at: position)
            
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        }
    }
}
