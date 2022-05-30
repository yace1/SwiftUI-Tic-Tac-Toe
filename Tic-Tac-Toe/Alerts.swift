//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Yacine  Bentayeb on 29.05.22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}


struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"),
                                    message: Text("You beat your AI well done"),
                                    buttonTitle: Text("Restart"))
    
    static let computerWin = AlertItem(title: Text("Your AI won"),
                                       message: Text("You AI well was better"),
                                       buttonTitle: Text("Try again"))
    
    static let Draw = AlertItem(title: Text("Draw"),
                                message: Text("You need some Practice"),
                                buttonTitle: Text("Try again"))
    
}
