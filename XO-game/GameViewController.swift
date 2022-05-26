//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    // MARK: - Private properties
    var stepInvoker: StepInvoker?
    private lazy var referee = Referee(gameboard: gameboard)
    private let gameboard = Gameboard()
    var currentState: GameState! {
        didSet {
            currentState.begin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch Game.shared.stepMode {
                case .onePerMove:
                    if let playerInputState = self.currentState as? PlayerInputState {
                        if playerInputState.player == .computer {
                            self.currentState.addRandomMark()
                            if self.currentState.isCompleted {
                                self.goToNextState()
                            }
                        }
                    }
                case .fivePerMove:
                    if let playerInputState = self.currentState as? PlayerStepsState {
                        if playerInputState.player == .computer {
                            for _ in 0..<5 {
                                if let playerInputState = self.currentState as? PlayerStepsState {
                                    if playerInputState.player == .computer {
                                        self.currentState.addRandomMark()
                                        if self.currentState.isCompleted {
                                            self.goToNextState()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stepInvoker = StepInvoker(source: self, gameboard: gameboard)
        switch Game.shared.mode {
        case .againstComputer:
            secondPlayerTurnLabel.text = "computer"
            
        case .twoPlayer:
            secondPlayerTurnLabel.text = "2nd player"
            
        }
        goToFirstState()
        setGameboardViewInitialState()
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restartGame)
        goToFirstState()
        stepInvoker?.clear()
    }
    
    // MARK: - Public functions
    
    func setFirstPlayerStep() {
        currentState = PlayerStepsState(
            player: .first,
            gameViewController: self,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: XView()
        )
    }
    
    // MARK: - Private functions
    
    
    private func setGameboardViewInitialState() {
        switch Game.shared.stepMode {
        case .onePerMove:
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                if let playerInputState = self.currentState as? PlayerInputState {
                    if playerInputState.player == .computer {
                        
                    } else {
                        self.currentState.addMark(at: position)
                        if self.currentState.isCompleted {
                            self.goToNextState()
                        }
                    }
                }
            }
        case .fivePerMove:
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                if let playerInputState = self.currentState as? PlayerStepsState {
                    if playerInputState.player == .computer {
                        
                    } else {
                        self.currentState.addMark(at: position)
                        if self.currentState.isCompleted {
                            self.goToNextState()
                        }
                    }
                }
            }
        }
    }
    
    private func goToFirstState() {
        let player: Player = .first
        switch Game.shared.stepMode {
        case .onePerMove:
            currentState =  PlayerInputState(
                player: .first,
                gameViewController: self,
                gameboard: gameboard,
                gameboardView: gameboardView,
                markViewPrototype: player.markViewPrototype
            )
        case .fivePerMove:
            currentState = PlayerStepsState(
                player: .first,
                gameViewController: self,
                gameboard: gameboard,
                gameboardView: gameboardView,
                markViewPrototype: player.markViewPrototype)
        }
        gameboardView.clear()
        gameboard.clear()
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(
                winner: winner,
                gameViewController: self
            )
            return
        }
        
        switch Game.shared.stepMode {
        case .onePerMove:
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                currentState =  PlayerInputState(
                    player: playerInputState.player.next,
                    gameViewController: self,
                    gameboard: gameboard,
                    gameboardView: gameboardView,
                    markViewPrototype: player.markViewPrototype
                )
            }
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else {
                return
            }
            if let playerInputState = currentState as? PlayerStepsState {
                if stepInvoker.commandsCount() < 5 {
                    
                } else {
                    if playerInputState.player == .first {
                        let player = playerInputState.player.next
                        currentState = PlayerStepsState(
                            player: player,
                            gameViewController: self,
                            gameboard: gameboard,
                            gameboardView: gameboardView,
                            markViewPrototype: player.markViewPrototype
                        )
                    }
                }
            }
        }
    }
}

