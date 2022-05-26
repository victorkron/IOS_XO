//
//  StepInvoker.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class StepInvoker {
    private var commands: [StepCommand] = []
    weak var source: GameViewController?
    let referee: Referee?
    
    init(source: GameViewController, gameboard: Gameboard) {
        self.source = source
        self.referee = Referee(gameboard: gameboard)
    }
    
    func commandsCount() -> Int {
        commands.count
    }
    
    func clear() {
        commands = []
    }
    
    func addCommand(_ command: StepCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    func chechWinner() -> Bool {
        guard
            let referee = referee,
            let source = source
        else { return false }

        if let winner = referee.determineWinner() {
            source.currentState = GameEndedState(
                winner: winner,
                gameViewController: source
            )
            return true
        }
        return false
    }
    
    func executeCommandsIfNeeded() {
        if commands.count == 10 {
            for index in 0..<Int(commands.count / 2) {
                commands[index].execute()
                if chechWinner() {
                    commands = []
                    return
                }
                commands[index + 5].execute()
                if chechWinner() {
                    commands = []
                    return
                }
            }
            commands = []
            source?.setFirstPlayerStep()
        }
    }
}
