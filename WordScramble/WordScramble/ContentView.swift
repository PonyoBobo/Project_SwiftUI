//
//  ContentView.swift
//  WordScramble
//
//  Created by Rich Bobo on 2022/3/30.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var gameScore = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    var body: some View {
        ZStack{
            Color.purple
                .opacity(0.5).edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Word Scramble")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .shadow(radius: 4)
                    .padding([.top,.bottom],25)
                
            VStack (spacing: 10){
                Text(rootWord)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(2)
                
                Spacer()
                
                TextField("Enter Your word", text: $newWord)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20.0)
                        .shadow(radius: 5)
                
                    List{
                        Section(header:Text("Used Word : ")){
                            ForEach(usedWords, id : \.self) { word in
                                HStack{
                                    Text(word)
                                    Image(systemName: "\(word.count).circle")
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .headerProminence(.standard)
                    }
                    .cornerRadius(27.5)
                    .shadow(radius: 10)

                Spacer()
                
                HStack{
                    Text("Your scores is")
                        .font(.headline)
                    Text("\(gameScore)")
                        .font(.title)
                }
                .padding()
                .background(.thinMaterial,in : RoundedRectangle(cornerRadius: 8))
                
               Button("restart"){startGame()}
        
                Spacer()
                Spacer()
            }
            .padding()
            }
            
        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError){
            Button("OK",role: .cancel){}
        }message: {
            Text(errorMessage)
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespaces)
        
        guard answer.count > 2 else{
            wordError(title: "Answer is too short", message: "Please make sure the word length is greater than 3 ")
            newWord = ""
            return
            
        }
        
        //更多功能
        guard isOriginal(word: answer) else{
            wordError(title: "Word used already", message: "Be more original")
            newWord = ""
            return
        }
        guard isPossible(word: answer) else{
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            newWord = ""
            return
        }
        guard isReal(word: answer) else{
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            newWord = ""
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
            newWord = ""
        }
        
        switch usedWords[0].count {
        case 4 :
            gameScore += 4
        case 5 :
            gameScore += 5
        case 6 :
            gameScore += 6
        case 7 :
            gameScore += 7
        case 8 :
            gameScore += 8
        default :
            gameScore += 3
        }
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                let allwords = startWords.components(separatedBy: "\n")
                rootWord = allwords.randomElement() ?? "Unkown"
                usedWords = [String]()
                gameScore = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word : String) -> Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(word : String)-> Bool{
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title : String,message : String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
