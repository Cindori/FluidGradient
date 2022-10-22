//
//  ContentView.swift
//  Teste
//
//  Created by João Gabriel Pozzobon dos Santos on 26/09/22.
//

import SwiftUI

struct ContentView: View {
    let colorPool: [Color] = [.blue, .green, .yellow, .orange, .red, .pink, .purple, .teal, .indigo]
    @State var colors: [Color] = []
    @State var highlights: [Color] = []
    @State var background = Color.black
    
    var body: some View {
        VStack {
            gradient
            
            Button("Add color") {
                colors = []
                highlights = []
                for _ in 0...Int.random(in: 3...8) {
                    colors.append(colorPool.randomElement()!)
                }
                for _ in 0...Int.random(in: 3...8) {
                    highlights.append(colorPool.randomElement()!)
                }
                background = colorPool.randomElement()!
            }
        }
    }
    
    var gradient: some View {
        FluidGradient(blobs: colors,
                      highlights: highlights, speed: 0.2)
        .background(background)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
