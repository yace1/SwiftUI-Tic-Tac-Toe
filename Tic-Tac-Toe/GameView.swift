//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Yacine  Bentayeb on 28.05.22.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                VStack(spacing: 0){
                    DifficultyTitle(geometry: geometry)
                    HStack (spacing: 0){
                        DifficultyButton(title: "Easy", geometry: geometry, vm: viewModel)
                        DifficultyButton(title: "Medium", geometry: geometry, vm: viewModel)
                        DifficultyButton(title: "Hard", geometry: geometry, vm: viewModel)
                    }
                }
                .padding(.bottom, 30)
                .cornerRadius(5)
                LazyVGrid(columns: viewModel.columns, spacing: 20){
                    ForEach(0..<9){ i in
                        ZStack{
                            GameSquareView(geometry: geometry)
                            PlayerIcon(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.IsGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()}))
            })
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let BoardIndex: Int
    
    var indicator: String { //image x or o
        if player == .human{ return "xmark"} else { return "circle"}
    }
}

struct GameSquareView: View{
    var geometry: GeometryProxy
    var body: some View {
        Rectangle()
            .foregroundColor(.blue)
            .frame(width: geometry.size.width / 3 - 20, height: geometry.size.width/3 - 20)
            .cornerRadius(5)
    }
}

struct PlayerIcon: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
    }
}

struct DifficultyTitle: View {
    var geometry: GeometryProxy
    var body: some View {
        Text("Difficulty")
            .frame(width: geometry.size.width - 30, height: geometry.size.width / 10)
            .font(.system(size: 23, weight: .bold, design: .default))
            .background(Color(red: 0.0, green: 0.0, blue: 0.6, opacity: 0.78))
            .foregroundColor(.white)
    }
}

struct DifficultyButton: View {
    var title: String
    var geometry: GeometryProxy
    var vm: GameViewModel
    var body: some View {
        Text(title)
            .frame(width: geometry.size.width/3 - 10, height: geometry.size.width/12)
            .font(.system(size: 15, weight: .bold, design: .default))
            .background(Color(red: 0.0,
                              green: 0.0,
                              blue: 1.0,
                              opacity: title==vm.gameDifficulty ? 1: 0.66))
            .foregroundColor(.white)
            .onTapGesture {
                vm.chooseDifficulty(difficulty: title)
            }
    }
}
