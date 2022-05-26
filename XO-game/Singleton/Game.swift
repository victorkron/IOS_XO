//
//  Game.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class Game {
    
    static let shared = Game()
    
    var mode: Mode = .againstComputer
    var stepMode: StepMode = .onePerMove
    
    private init() {
        
    }
}

