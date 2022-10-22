//
//  FluidGradient.swift
//  FluidGradient
//
//  Created by Oskar Groth on 2021-12-23.
//

import SwiftUI

public struct FluidGradient: View {
    private var blobs: [Color]
    private var highlights: [Color]
    private var speed: CGFloat
    private var blur: CGFloat
    
    public init(blobs: [Color],
                highlights: [Color] = [],
                speed: CGFloat = 1.0,
                blur: CGFloat = 0.75) {
        self.blobs = blobs
        self.highlights = highlights
        self.speed = speed
        self.blur = blur
    }
    
    public var body: some View {
        Representable(blobs: blobs,
                      highlights: highlights,
                      speed: speed,
                      blur: blur)
            .accessibility(hidden: true)
            .clipped()
    }
}

#if os(OSX)
typealias SystemRepresentable = NSViewRepresentable
#else
typealias SystemRepresentable = UIViewRepresentable
#endif

// MARK: - Representable
extension FluidGradient {
    struct Representable: SystemRepresentable {
        var blobs: [Color]
        var highlights: [Color]
        var speed: CGFloat
        var blur: CGFloat
        
        func makeView(context: Context) -> FluidGradientView {
            context.coordinator.view
        }
        
        func updateView(_ view: FluidGradientView, context: Context) {
            context.coordinator.create(blobs: blobs, highlights: highlights)
            context.coordinator.update(speed: speed, blur: blur)
        }
        
        #if os(OSX)
        func makeNSView(context: Context) -> FluidGradientView {
            makeView(context: context)
        }
        func updateNSView(_ view: FluidGradientView, context: Context) {
            updateView(view, context: context)
        }
        #else
        func makeUIView(context: Context) -> FluidGradientView {
            makeView(context: context)
        }
        func updateUIView(_ view: FluidGradientView, context: Context) {
            updateView(view, context: context)
        }
        #endif
        
        func makeCoordinator() -> Coordinator {
            Coordinator(blobs: blobs,
                        highlights: highlights,
                        speed: speed,
                        blur: blur)
        }
    }

    class Coordinator {
        var blobs: [Color]
        var highlights: [Color]
        var speed: CGFloat
        var blur: CGFloat
        
        var view: FluidGradientView
        
        init(blobs: [Color],
             highlights: [Color],
             speed: CGFloat,
             blur: CGFloat) {
            self.blobs = blobs
            self.highlights = highlights
            self.speed = speed
            self.blur = blur
            self.view = FluidGradientView(blobs: blobs,
                                          highlights: highlights,
                                          speed: speed,
                                          blur: blur)
        }
        
        /// Create blobs and highlights
        func create(blobs: [Color], highlights: [Color]) {
            guard blobs != self.blobs || highlights != self.blobs else { return }
            view.create(blobs, layer: view.baseLayer)
            view.create(highlights, layer: view.highlightLayer)
        }
        
        /// Update speed and blur coefficient
        func update(speed: CGFloat, blur: CGFloat) {
            guard speed != self.speed || blur != self.blur else { return }
            self.speed = speed
            self.blur = blur
            view.update(speed: speed, blur: blur)
        }
    }
}

struct AuroraPreview: PreviewProvider {
    static var previews: some View {
        FluidGradient(blobs: [.red, .blue, .green], highlights: [])
    }
}
