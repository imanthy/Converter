//
//  ContentView.swift
//  Converter
//
//  Created by Anthy Chen on 3/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var input_value = 0.0
    @State private var input_unit = UnitLength.meters
    @State private var output_unit = UnitLength.kilometers
    @FocusState private var inputIsFocused: Bool
    
    let unit_selection: [UnitLength] = [.feet, .meters, .kilometers, .miles, .yards]
    let formatter: MeasurementFormatter
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
    }
    var output: String {
        let input_measurement = Measurement(value: input_value, unit: input_unit)
        let output_measurement = input_measurement.converted(to: output_unit)
        return formatter.string(from: output_measurement)
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
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Picker("Convert to", selection: $output_unit) {
                    ForEach(unit_selection, id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Section {
                    Text(output)
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
