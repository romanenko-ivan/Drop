//
//  ContentView.swift
//  Drop
//
//  Created by Романенко Иван on 26.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var location = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    @State private var offSet = CGSize.zero
    
    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offSet = value.translation
            }.onEnded { value in
                withAnimation(.spring(bounce: 0.3)) {
                    offSet = .zero
                }
            }
    }
    
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    gradient: .init(colors: [Color.yellow, Color.red]),
                    center: .center,
                    startRadius: 60,
                    endRadius: 120
                )
            )
            .mask {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5))
                    context.addFilter(.blur(radius: 25))
                    
                    let shapeOne = context.resolveSymbol(id: 1)!
                    let shapeTwo = context.resolveSymbol(id: 2)!
                    
                    context.drawLayer { context in
                        context.draw(shapeOne, at: location)
                        context.draw(shapeTwo, at: location)
                    }
                } symbols: {
                    Circle()
                        .frame(width: 100, height: 100)
                        .tag(1)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .offset(x: offSet.width, y: offSet.height)
                        .tag(2)
                }
            }
            .overlay {
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .offset(x: offSet.width, y: offSet.height)
            }
            .ignoresSafeArea()
            .gesture(gesture)
            .background(.primary)
    }
}

#Preview {
    ContentView()
}
