<h1> 🐰 Fluid Gradient
  <img align="right" alt="Project logo" src="./assets/icon-small.png" width=74px>
</h1>

<p>
    <img src="https://img.shields.io/badge/-SwiftUI-red.svg" />
    <img src="https://img.shields.io/badge/-CoreAnimation-grey.svg" />
</p>

A fluid, animated gradient implemented with CoreAnimation and SwiftUI, made available as a [Swift Package](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

## How it works

This implementation works by displaying stacked "blobs" in a coordinate space, and blurring them afterwards to make it seem seamless. The blobs are simple `CAGradientLayer` layers added to two separate `CALayer` layers: base and highlight. The latter one has an overlay blend mode to create unique patterns. You can optionally provide colors for both the base and highlight layers.

> **Note**
> You can learn to code this project by yourself in a series of development tutorial articles written for the [Cindori Blog](https://cindori.com/developer/animated-gradient).
> - [Building a fluid gradient with CoreAnimation & SwiftUI: Part 1](https://cindori.com/developer/animated-gradient)
> - [Building a fluid gradient with CoreAnimation & SwiftUI: Part 2](https://cindori.com/developer/animated-gradient-2)

## Example usage

You can find an example buildable project that uses FluidGradient in the root of this repository. To use it in your app, you can start with the following:

```
import SwiftUI
import FluidGradient

struct ContentView: View {
    var body: some View {
        FluidGradient(blobs: [.red, .green, .blue],
                      highlights: [.yellow, .orange, .purple],
                      speed: 1.0,
                      blur: 0.75)
          .background(.quaternary)
    }
}
```

---



