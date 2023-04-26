//
//  Alerts.swift
//  TickTacToe
//
//  Created by user236029 on 4/25/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}


struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Way to Go!"),
                             buttonTitle: Text("Ok"))
    static let ComputerWin = AlertItem(title: Text("You Lost"),
                             message: Text("Better luck next time."),
                             buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw!"),
                             message: Text("Valiant Effort"),
                             buttonTitle: Text("Try Again"))
}
