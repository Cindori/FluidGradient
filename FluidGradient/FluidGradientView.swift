//
//  NSAuroraView.swift
//  NSAuroraView
//
//  Created by Oskar Groth on 2021-12-23.
//

import SwiftUI
import Combine

#if os(OSX)
import AppKit
public typealias SystemColor = NSColor
public typealias SystemView = NSView
#else
import UIKit
public typealias SystemColor = UIColor
public typealias SystemView = UIView
#endif

/// A system view that presents an animated gradient with ``CoreAnimation``
public class FluidGradientView: SystemView {
    var speed: CGFloat
    var blur: CGFloat
    
    let baseLayer = ResizableLayer()
    let highlightLayer = ResizableLayer()
    let blurLayer = ResizableLayer()
    
    var cancellables = Set<AnyCancellable>()
    
    init(blobs: [Color] = [],
         highlights: [Color] = [],
         speed: CGFloat = 1.0,
         blur: CGFloat = 0.75) {
        self.speed = speed
        self.blur = blur
        super.init(frame: .zero)
        
        if let filter = CIFilter(name:"CIGaussianBlur") {
            filter.name = "blur"
            blurLayer.backgroundFilters = [filter]
        }
        
        if let compositingFilter = CIFilter(name: "CIOverlayBlendMode") {
            highlightLayer.compositingFilter = compositingFilter
        }
        //highlightLayer.backgroundFilters = ["overlayBlendMode"]
        
        #if os(OSX)
        layer = ResizableLayer()
        
        wantsLayer = true
        postsFrameChangedNotifications = true
        
        layer?.delegate = self
        baseLayer.delegate = self
        highlightLayer.delegate = self
        blurLayer.delegate = self
        
        self.layer?.addSublayer(baseLayer)
        self.layer?.addSublayer(highlightLayer)
        self.layer?.addSublayer(blurLayer)
        #else
        self.layer.addSublayer(baseLayer)
        self.layer.addSublayer(highlightLayer)
        self.layer.addSublayer(blurLayer)
        #endif
        
        create(blobs, layer: baseLayer)
        create(highlights, layer: highlightLayer)
        //update(speed: speed, blur: blur)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(color: Color, layer: CAGradientLayer) {
        layer.colors = [SystemColor(color).cgColor,
                        SystemColor(color).cgColor,
                        SystemColor(color.opacity(0.0)).cgColor]
        layer.locations = [0.0, 0.9, 1.0]
    }
    
    /// Create blobs and add to specified layer
    public func create(_ colors: [Color], layer: CALayer) {
        // Remove blobs at the end if colors are removed
        let removeCount = layer.sublayers?.count ?? 0 - colors.count
        if removeCount > 0 {
            layer.sublayers?.removeLast(removeCount)
        }
        
        for (index, color) in colors.enumerated() {
            if index < layer.sublayers?.count ?? 0 {
                if let existing = layer.sublayers?[index] as? BlobLayer {
                    if existing.colors?.first as! CGColor != SystemColor(color).cgColor {
                        existing.set(color: color)
                    }
                }
            }
            layer.addSublayer(BlobLayer(color: color))
        }
    }
    
    /// Update sublayers and set speed and blur levels
    public func update(speed: CGFloat, blur: CGFloat) {
        guard speed > 0 else { return }
        self.speed = speed
        self.blur = blur
        updateBlur()
        
        let layers = (baseLayer.sublayers ?? []) + (highlightLayer.sublayers ?? [])
        for layer in layers {
            if let layer = layer as? BlobLayer {
                Timer.publish(every: .random(in: 0.8/speed...1.2/speed), on: .main, in: .common)
                    .autoconnect()
                    .sink { _ in
                        #if os(OSX)
                        let visible = self.window?.occlusionState.contains(.visible)
                        guard visible == true else { return }
                        #endif
                        layer.animate(speed: speed)
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    /// Compute and update new blur value
    private func updateBlur() {
        blurLayer.setValue(pow(min(frame.width, frame.height), blur),
                           forKeyPath: "backgroundFilters.blur.inputRadius")
    }
    
    /// Functional methods
    #if os(OSX)
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        let scale = window?.backingScaleFactor ?? 2
        layer?.contentsScale = scale
        baseLayer.contentsScale = scale
        highlightLayer.contentsScale = scale
        
        updateBlur()
    }
    
    public override func resize(withOldSuperviewSize oldSize: NSSize) {
        updateBlur()
    }
    #else
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.frame = self.frame
        //updateBlur()
        layer.layoutSublayers()
    }
    #endif
}

#if os(OSX)
extension FluidGradientView: CALayerDelegate, NSViewLayerContentScaleDelegate {
    public func layer(_ layer: CALayer,
                      shouldInheritContentsScale newScale: CGFloat,
                      from window: NSWindow) -> Bool {
        return true
    }
}
#endif
