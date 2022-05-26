//
//  MenuViewControllew.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class MenuViewControllew: UIViewController {
    
    private var mode: Mode?
    private var stepMode: StepMode?
    
    @IBOutlet var modeController: UISegmentedControl!
    @IBOutlet var stepModeController: UISegmentedControl!
    
    
    // MARK: - Actions
    
    @IBAction func modeChange(_ sender: UISegmentedControl) {
        setMode()
    }
    
    @IBAction func stepModeChange(_ sender: Any) {
        setStepMode()
    }
    
    
    @IBAction func goToNextVC(_ sender: Any) {
        if let mode = mode, let stepMode = stepMode {
            Game.shared.mode = mode
            Game.shared.stepMode = stepMode
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setMode()
        setStepMode()
    }
    
    func setMode() {
        switch modeController.selectedSegmentIndex {
        case 0:
            mode = .twoPlayer
        case 1:
            mode = .againstComputer
        default:
            mode = .againstComputer
        }
    }
    
    func setStepMode() {
        switch stepModeController.selectedSegmentIndex {
        case 0:
            stepMode = .onePerMove
        case 1:
            stepMode = .fivePerMove
        default:
            stepMode = .onePerMove
        }
    }
}
