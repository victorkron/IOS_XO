//
//  Invoker.swift
//  XO-game
//
//  Created by Карим Руабхи on 26.05.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class LoggerInvoker {
    
    static let shared = LoggerInvoker()
    
    private let logger = Logger()
    private let batchSize = 10
    private var commands: [LogCommand] = []
    
    func addCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    func executeCommandsIfNeeded() {
        guard
            commands.count >= batchSize
        else { return }
        
        commands.forEach { command in
            logger.writeMessageToLog(command.logMessage)
        }
        commands = []
    }
}

public func log(_ action: LogAction) {
    let command = LogCommand(action: action)
    LoggerInvoker.shared.addCommand(command)
}
