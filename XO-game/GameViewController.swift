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
    
    private lazy var referee = Referee(gameboard: gameboard)
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restartGame)
    }
    
    // MARK: - Private functions
    
    func goToFirstState() {
        let player: Player = .first
        
        currentState =  PlayerInputState(
            player: .first,
            gameViewController: self,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: player.markViewPrototype
        )
    }
    
    func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(
                winner: winner,
                gameViewController: self
            )
            return
        }
        
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
    }
}

