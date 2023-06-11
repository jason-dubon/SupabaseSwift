//
//  HomeView.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/10/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        if let appUser = appUser {
            VStack {
                Text(appUser.uid)
                
                Text(appUser.email ?? "No Email")
                
                Button {
                    Task {
                        do {
                            try await AuthManager.shared.signOut()
                            self.appUser = nil
                        } catch {
                            print("unable to sign out")
                        }
                    }
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                Task {
                    do {
                        try await ToDoViewModel().fetchItems(for: appUser.uid)
                    } catch {
                        print(error)
                    }
                    
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appUser: .constant(.init(uid: "1234", email: "jason@gmail.com")))
    }
}
