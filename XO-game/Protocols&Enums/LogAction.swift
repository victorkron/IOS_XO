//
//  LogAction.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public enum LogAction {
    case playerInput(play: Player, position: GameboardPosition)
    case gameFinished(winner: Player?)
    case restartGame
}
