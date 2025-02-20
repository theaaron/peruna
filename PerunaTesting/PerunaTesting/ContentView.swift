//
//  ContentView.swift
//  PerunaTesting
//
//  Created by aaron on 2/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            PerunaView()
                .ignoresSafeArea()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
