//
//  CreateToDoView.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/27/23.
//

import SwiftUI

struct CreateToDoView: View {
    @EnvironmentObject var viewModel: ToDoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var appUser: AppUser
    @State var text = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Create a To Do")
                .font(.largeTitle)
            
            AppTextField(placeHolder: "Please enter your task", text: $text)
            
            Button {
                if text.count > 2 {
                    Task {
                        do {
                            try await viewModel.createItem(text: text, uid: appUser.uid)
                            dismiss()
                        } catch {
                            print("error")
                        }
                    }
                }
            } label: {
                Text("Create")
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
    }
    
}

struct CreateToDoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateToDoView(appUser: .init(uid: "", email: ""))
            .environmentObject(ToDoViewModel())
    }
}
