//
//  Home.swift
//  HabitTracker
//
//  Created by Jonatas Falkaniere on 31/08/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Meus Hábitos")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading )
                .overlay(alignment: .trailing) {
                    Button { 
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        
    }
}

#Preview {
    Home()
}
