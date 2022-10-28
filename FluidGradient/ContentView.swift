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
    
    @State var blur = 0.75
    
    var body: some View {
        VStack {
            gradient
                .cornerRadius(16)
                .padding(16)
            
            Button("Update") {
                setColors()
            }
        }.onAppear {
            setColors()
        }
        .onTapGesture {
            blur = blur == 0 ? 0.75 : 0.0
        }
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
                      highlights: highlights, speed: 1.2, blur: 0)
        //.background(background)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
