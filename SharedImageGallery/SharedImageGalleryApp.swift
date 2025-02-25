//
//  SharedImageGalleryApp.swift
//  SharedImageGallery
//
//  Created by Carlos Aguilar on 2/24/25.
//

import Amplify
import Authenticator
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import SwiftUI

@main
struct SharedImageGalleryApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            let amplifyModels = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: amplifyModels))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: amplifyModels))
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify: \(error)")
        }
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
