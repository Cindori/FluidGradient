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
    
    @State var speed = 1.0
    
    var body: some View {
        FluidGradient(blobs: [.red, .green, .blue],
                      highlights: [.yellow, .orange, .purple])
        .background(.quaternary)
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
        background = colorPool.randomElement()!
    }
    
    var gradient: some View {
        //Rectangle()
        FluidGradient(blobs: colors,
                      highlights: highlights, speed: speed)
        //.background(background)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
