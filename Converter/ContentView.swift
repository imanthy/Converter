//
//  ContentView.swift
//  Converter
//
//  Created by Anthy Chen on 3/10/23.
//

import SwiftUI

enum LengthUnit: String {
    case feet = "Feet"
    case meters = "Meters"
    case kilometers = "Kilometers"
    case miles = "Miles"
    case yards = "Yards"
}

struct ContentView: View {
    
    @State private var input_value = 0.0
    @State private var input_unit: LengthUnit = .meters
    @State private var output_unit: LengthUnit = .kilometers
    @FocusState private var inputIsFocused: Bool
    let unit_selection: [LengthUnit] = [.feet, .meters, .kilometers, .miles, .yards]
    var output_value: Double {
        let inputToMetersMultiplier: Double
        let metersToOutputMultiplier: Double
        
        switch input_unit {
        case .feet:         inputToMetersMultiplier = 0.3048
        case .kilometers:   inputToMetersMultiplier = 1000
        case .miles:        inputToMetersMultiplier = 1609.34
        case .yards:        inputToMetersMultiplier = 0.9144
        default:            inputToMetersMultiplier = 1.0
        }
        switch output_unit {
        case .feet:         metersToOutputMultiplier = 3.28084
        case .kilometers:   metersToOutputMultiplier = 0.001
        case .miles:        metersToOutputMultiplier = 0.000621371
        case .yards:        metersToOutputMultiplier = 1.09361
        default:            metersToOutputMultiplier = 1.0
        }
        return (input_value * inputToMetersMultiplier * metersToOutputMultiplier)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Value", value: $input_value, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                } header: {
                    Text("Value to conver")
                }
                
                Picker("Convert from", selection: $input_unit) {
                    ForEach(unit_selection, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                Picker("Convert to", selection: $output_unit) {
                    ForEach(unit_selection, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                Section {
                    Text("\(output_value.formatted()) \(output_unit.rawValue)")
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
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
