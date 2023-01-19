//
//  ContentView.swift
//  FluidGradientExample
//
//  Created by João Gabriel Pozzobon dos Santos on 28/11/22.
//

import SwiftUI
import FluidGradient

struct ContentView: View {
    @State var colors: [Color] = []
    @State var highlights: [Color] = []
    
    @State var speed = 1.0
    
    let colorPool: [Color] = [.blue, .green, .yellow, .orange, .red, .pink, .purple, .teal, .indigo]
    
    var body: some View {
        VStack {
            gradient
                .backgroundStyle(.quaternary)
                .cornerRadius(16)
                .padding(4)
            
            HStack {
                Button("Randomize colors", action: setColors)
                Slider(value: $speed, in: 0...5)
            }.padding(4)
        }
        .padding(16)
        .navigationTitle("FluidGradient")
        .onAppear(perform: setColors)
    }
    
    func setColors() {
        colors = []
        highlights = []
        for _ in 0...Int.random(in: 5...5) {
            colors.append(colorPool.randomElement()!)
        }
        for _ in 0...Int.random(in: 5...5) {
            highlights.append(colorPool.randomElement()!)
        }
    }
    
    var gradient: some View {
        FluidGradient(blobs: colors,
                      highlights: highlights,
                      speed: speed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
