//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rich Bobo on 2022/3/14.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userCorrect = true
    @State private var userSocre = 0
    @State private var finalScore = 0
    @State private var gameOver = false
    @State private var questionsCount = 0
    
    @State private var animationAmount = 0.0
    @State private var animateOpacity = 1.0
    @State private var besidesTheCorrect = false
    @State private var besidesTheWrong = false
    @State private var selectedFlag = 0
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
  
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45),location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26),location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                

                VStack(spacing:15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.bold())
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){number in
                        Button{
                            flagTapped(number)
                            selectedFlag = number
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(number == correctAnswer ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number != correctAnswer && besidesTheCorrect ? animateOpacity : 1 )
                                .background(besidesTheWrong && selectedFlag == number ? Capsule(style: .circular).fill(Color.red).blur(radius: 30) : Capsule(style: .circular).fill(Color.clear).blur(radius: 0))
                                .opacity(besidesTheWrong && selectedFlag != number ? animateOpacity : 1)
                        }
                    }
                    .frame(maxWidth:.infinity)
                    .padding(.vertical,40)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                
                VStack{
                    Spacer()
                    Spacer()
                    Text("Your score is \(userSocre)")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue",action: askingQuestion)
        }message: {
            if scoreTitle == "Correct"{
                Text("Your score plus 100 ")
            }
        }
        
        .alert("Final Score", isPresented: $gameOver){
            Button("Restart Game",action: askingQuestion)
        }message: {
            Text("Your final score is \(finalScore)")
        }
}
    
    func flagTapped(_ number : Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            userCorrect = true
            userSocre += 100
            finalScore += 100
            
            withAnimation{
                animationAmount += 360
                animateOpacity = 0.25
                besidesTheCorrect = true
            }
        }else{
            scoreTitle = "That's the flag of \(countries[number])"
            userCorrect = false
            
             withAnimation{
                animateOpacity = 0.25
                besidesTheWrong = true
            }  
        }
        questionsCount += 1
        showingScore = true
    }
    
    func askingQuestion(){
        if questionsCount == 8 {
          flagGameOver()
        }else{
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            besidesTheCorrect = false
            besidesTheWrong = false
        }
    }
   
    func flagGameOver(){
        gameOver = true
        questionsCount = 0
        userSocre = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
