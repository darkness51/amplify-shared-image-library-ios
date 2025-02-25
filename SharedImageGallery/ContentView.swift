//
//  ContentView.swift
//  SharedImageGallery
//
//  Created by Carlos Aguilar on 2/24/25.
//

import Amplify
import Authenticator
import SwiftUI

struct ContentView: View {
    var body: some View {
        Authenticator { state in
            VStack {
                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
