//
//  ContentView.swift
//  Example
//
//  Created by Arthur Guibert on 08/05/2023.
//

import SwiftUI
import Combine
import MulticolorGradient

struct ContentView: View {
    @State private var selectedItem = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedItem) {
                StaticSampleGradient().tag(0)
                SimpleAnimatedGradient().tag(1)
                ComplexAnimatedGradient().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 8.0) {
                Text("01").foregroundColor(selectedItem == 0 ? .white : .init(white: 1.0, opacity: 0.3))
                Text("02").foregroundColor(selectedItem == 1 ? .white : .init(white: 1.0, opacity: 0.3))
                Text("03").foregroundColor(selectedItem == 2 ? .white : .init(white: 1.0, opacity: 0.3))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct StaticSampleGradient: View {
    @State private var animationAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: Color(hex: 0xffbe0b))
                ColorStop(position: .bottomLeading, color: Color(hex: 0xfb5607))
                ColorStop(position: .topTrailing, color: Color(hex: 0xff006e))
                ColorStop(position: .bottomLeading, color: Color(hex: 0x8338ec))
                ColorStop(position: .trailing, color: Color(hex: 0x3a86ff))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SimpleAnimatedGradient: View {
    @State private var animationAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: Color(white: 0.0))
                ColorStop(position: UnitPoint(x: 0.7, y: animationAmount), color: Color(white: 0.2))
                ColorStop(position: UnitPoint(x: animationAmount, y: 0.3), color: Color(white: 0.3))
            }
            .noise(64)
            .power(10.0)
            .edgesIgnoringSafeArea(.all).onAppear {
                withAnimation(.linear(duration: 3).repeatForever()) {
                    animationAmount = 1.0
                }
            }
        }
    }
}

struct ComplexAnimatedGradient: View {
    @State private var animationAmount: CGFloat = 0.0
    @State private var timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: Color(hex: 0xd62828))
                ColorStop(position: UnitPoint(x: 0.5 + sin(animationAmount * 0.8) * 0.5,
                                              y: 0.5 + cos(animationAmount * 0.8) * 0.5), color: Color(hex: 0x003049))
                ColorStop(position: UnitPoint(x: 0.5 - sin(animationAmount) * 0.45,
                                              y: 0.5 + cos(animationAmount) * 0.5), color: Color(hex: 0x003049))
                ColorStop(position: UnitPoint(x: 0.5, y: 0.5), color: Color(hex: 0xf77f00))
            }
            .noise(32.0)
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { time in
                animationAmount += 1.0 / 60.0
            }
        }.onAppear {
            timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
        }.onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
