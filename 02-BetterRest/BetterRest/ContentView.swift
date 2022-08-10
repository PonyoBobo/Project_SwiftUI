//
//  ContentView.swift
//  BetterRest
//
//  Created by Rich Bobo on 2022/3/25.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var suggestSleepTime = ""
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    DatePicker("Please enter a time",selection: $wakeUp,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp){newValue in calculateBedTime()
                        }
                }header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section{
                    Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount,in: 4...12,step: 0.25)
                        .onChange(of: sleepAmount){newValue in calculateBedTime()
                        }
                }header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section{
                    Picker("Number of coffee",selection: $coffeeAmount){
                        ForEach(1 ..< 13){
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                        .onChange(of: coffeeAmount){newValue in calculateBedTime()
                        }
                    }
                }header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section{
                      Text(suggestSleepTime)
                          .padding(40)
                          .foregroundColor(.blue)
                          .background(Color(.init(red: 0.9, green: 0.9, blue: 1, alpha: 50)))
                          .font(.system(size: 50, weight: .bold))
                          .cornerRadius(30)
                    
                }header: {
                    Text("Optimised Bedtime").font(.headline)
                }
    
            }
            .navigationTitle("BetterRest")
            .onAppear{
                calculateBedTime()
            }
        
        }
    }
    
    func calculateBedTime(){
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            suggestSleepTime = sleepTime.formatted(date: .omitted, time: .shortened)
            
        }catch{
            print("There was a problem loading the ML model")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
