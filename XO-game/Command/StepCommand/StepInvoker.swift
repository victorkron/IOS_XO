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
            source?.restartButton.isHidden = true
            for index in 0..<Int(commands.count / 2) {
                if self.chechWinner() {
                    self.commands = []
                    return
                }
                
                commands[index].execute(delay: Double(index))
                if self.chechWinner() {
                    self.commands = []
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                        self.source?.restartButton.isHidden = false
                    }
                    return
                }
                
                self.commands[index + 5].execute(delay: Double(index) + 0.5)
                if self.chechWinner() {
                    self.commands = []
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) + 0.5) {
                        self.source?.restartButton.isHidden = false
                    }
                    return
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.source?.restartButton.isHidden = false
                self.commands = []
                self.source?.setFirstPlayerStep()
            }
            
        }
    }
}
