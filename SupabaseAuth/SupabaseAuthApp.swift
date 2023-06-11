//
//  SupabaseAuthApp.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/10/23.
//

import SwiftUI
import GoogleSignIn

@main
struct SupabaseAuthApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
