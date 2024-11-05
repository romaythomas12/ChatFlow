//
//  SpinnerView.swift
//  ChatFlow
//
//  Created by Thomas Romay on 05/11/2024.
//

import SwiftUI
struct SpinnerView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0, anchor: .center)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        // TODO:
                    }
                }
            Spacer()
        }
    }
}
