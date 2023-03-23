//
//  ContentView.swift
//  Converter
//
//  Created by Anthy Chen on 3/10/23.
//

import SwiftUI

enum Conversions: String {
    case Distance,Volume,Temperature, Time
}

struct ContentView: View {
    
    @State private var selected_conversion_index = 0
    @State private var input_value = 0.0
    @State private var input_unit: Dimension = UnitLength.meters
    @State private var output_unit: Dimension = UnitLength.kilometers
    @FocusState private var inputIsFocused: Bool
    
    let conversions: [Conversions] = [.Distance, .Volume, .Temperature, .Time]
    let unit_types = [
        Conversions.Distance    : [UnitLength.centimeters, UnitLength.meters, UnitLength.kilometers, UnitLength.miles, UnitLength.inches, UnitLength.feet],
        Conversions.Volume      : [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        Conversions.Temperature : [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        Conversions.Time        : [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds, UnitDuration.milliseconds, UnitDuration.microseconds]
    ]
    
    let formatter: MeasurementFormatter
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .medium
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
                
                Picker("Conversion", selection: $selected_conversion_index) {
                    ForEach(0..<conversions.count) {
                        Text(conversions[$0].rawValue)
                    }
                }
                
                Picker("Convert from", selection: $input_unit) {
                    ForEach(unit_types[conversions[selected_conversion_index]]!, id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Picker("Convert to", selection: $output_unit) {
                    ForEach(unit_types[conversions[selected_conversion_index]]!, id: \.self) {
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
            .onChange(of: selected_conversion_index) { new_selection_index in
                let units = unit_types[conversions[new_selection_index]]
                input_unit = units![0]
                output_unit = units![1]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
