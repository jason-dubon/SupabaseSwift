//
//  SignInView.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/10/23.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistrationPresented = false
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                AppTextField(placeHolder: "Email address", text: $email)
                
                AppSecureField(placeHolder: "Password", text: $password)
            }
            .padding(.horizontal, 24)
            
            Button("New User? Register Here") {
                isRegistrationPresented.toggle()
            }
            .foregroundColor(Color(uiColor: .label))
            .sheet(isPresented: $isRegistrationPresented) {
                RegistrationView(appUser: $appUser)
                    .environmentObject(viewModel)
            }
            
            Button {
                Task {
                    do {
                        let appUser = try await viewModel.signInWithEmail(email: email, password: password)
                        self.appUser = appUser
                    } catch {
                        print("issue with sign in")
                    }
                }
            } label: {
                Text("Sign In")
                    .padding()
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(Color(uiColor: .label))
                    }
            }
            .padding(.horizontal, 24)
            
            VStack {
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.signInWithApple()
                            self.appUser = appUser
                        } catch {
                            print("error signing in")
                        }
                    }
                } label: {
                    Text("Sign in with Apple")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color(uiColor: .label))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .label), lineWidth: 1)
                        }
                }
                
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.signInWithGoogle()
                            self.appUser = appUser
                        } catch {
                            print("error signing in")
                        }
                    }
                } label: {
                    Text("Sign in with Google")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color(uiColor: .label))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .label), lineWidth: 1)
                        }
                }
            }
            .padding(.top)
            .padding(.horizontal, 24)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(appUser: .constant(.init(uid: "1234", email: nil)))
    }
}
