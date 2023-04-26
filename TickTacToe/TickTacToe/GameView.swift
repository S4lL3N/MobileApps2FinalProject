//
//  GameView.swift
//  TickTacToe
//
//  Created by user236029 on 4/25/23.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
   
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Text("Tic Tac Toe").font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.top, 40)
                                    .foregroundColor(.white)
                
                LazyVGrid(columns: viewModel.columns, spacing:5){
                    ForEach(0..<9){ i in
                        ZStack{
                            GameCircleView(proxy: geometry)
                            GameMarkerView(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }.onTapGesture {
                            viewModel.processMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .disabled(viewModel.isBoardDisabled)
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle , action:{viewModel.resetGame()}))
            })
            .background(Color.black)
        }
    }
    
    
}

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator:String {
        return player == .human ? "xmark" : "circle"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameCircleView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct GameMarkerView: View {
    var systemImageName : String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width:40, height:40)
            .foregroundColor(.white)
    }
}
