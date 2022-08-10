//
//  ContentView.swift
//  Length Conversion
//
//  Created by Rich Bobo on 2022/3/11.
//

import SwiftUI

struct ContentView: View {
    @State private var input = 100.0
    @State private var inputUnit = "Meters"
    @State private var outputUnit = "Kilometers"
    @FocusState private var inputIsFocused : Bool
    
    let lengthUnit = ["Meters", "Kilometers", "Feet", "Yards", "Miles"]
    
    var result : String {
        
        var inputToMeter : Double
        var meterToOutput : Double
        
        switch inputUnit {
        case "Meters" :
            inputToMeter = 1.0
        case "Kilometers" :
            inputToMeter = 1000.0
        case "Feet" :
            inputToMeter = 0.3048
        case "Yards" :
            inputToMeter = 0.9144
        case "Miles" :
            inputToMeter = 1609.34
        default :
            inputToMeter = 1.0
            
        }
        
        switch outputUnit{
        case "Meters" :
            meterToOutput = 1.0
        case "Kilometers" :
            meterToOutput = 0.001
        case "Feet" :
            meterToOutput = 3.28084
        case "Yards" :
            meterToOutput = 1.09361
        case "Miles" :
            meterToOutput = 0.000621371
        default :
            meterToOutput = 1.0
        }
       
        let inputInMeters = input * inputToMeter
        let output = inputInMeters * meterToOutput
        
        let outputString = output.formatted()
        return "\(outputString) \(outputUnit.lowercased())"
        
    }
        

    
    var body: some View {
        NavigationView{
            Form{
                Section(header:Text( "Input")){
                    TextField("Your input amount",value: $input,format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                }
                
                Section{
                    Picker("Select your unit",selection: $inputUnit){
                        ForEach(lengthUnit,id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }header: {
                    Text("Select input unit")
                }
                
                Section{
                    Picker("Select your unit",selection: $outputUnit){
                        ForEach(lengthUnit,id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }header: {
                    Text("Select output unit")
                }
                
                Section(header:Text("Output")){
                    Text(result)
                }
            }
            .navigationTitle("Length Conversion")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    
                    Button("Done"){
                        inputIsFocused = false
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
