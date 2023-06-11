//
//  ToDoView.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/23/23.
//

import SwiftUI
import PhotosUI

struct ToDoView: View {
    @StateObject var viewModel = ToDoViewModel()
    
    @Binding var appUser: AppUser?
    @State var showPhotoActionSheet = false
    @State var showPhotoLibrary = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var profileImage = Image(systemName: "person")
    
    var body: some View {
        if let appUser {
            NavigationStack {
                ZStack {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.todos, id: \.text) { todo in
                                ToDoItemView(todo: todo)
                                    .environmentObject(viewModel)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .background(Color(red: 39/255, green: 40/255, blue: 39/255))
                .navigationTitle("To Do")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .cornerRadius(16)
                            .onTapGesture {
                                showPhotoActionSheet.toggle()
                            }
                            .contextMenu {
                                Button {
                                    Task {
                                        do {
                                            try await AuthManager.shared.signOut()
                                            self.appUser = nil
                                        } catch {
                                            print("errror signing out")
                                            print(error)
                                        }
                                    }
                                } label: {
                                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            }
                            .confirmationDialog("Select A Profile Photo", isPresented: $showPhotoActionSheet) {
                                Button {
                                    showPhotoLibrary.toggle()
                                } label: {
                                    Text("Photo Library")
                                }

                            }
                            .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedPhoto, photoLibrary: .shared())
                            .onChange(of: selectedPhoto) { newValue in
                                guard let photoItem = selectedPhoto else {
                                    return
                                }
                                
                                Task {
                                    if let photoData = try await photoItem.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: photoData) {
                                        do {
                                            try await StorageManager.shared.uploadProfilePhoto(for: appUser, photoData: photoData)
                                        } catch {
                                            print(error)
                                        }
                                        await MainActor.run {
                                            profileImage = Image(uiImage: uiImage)
                                        }
                                    }
                                }
                            }
                    }
                }
                .toolbar {
                    NavigationLink {
                        CreateToDoView(appUser: appUser)
                            .environmentObject(viewModel)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.all, 2)
                            .foregroundColor(Color(red: 62/255, green: 207/255, blue: 142/255))
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await viewModel.fetchItems(for: appUser.uid)
                            let uiImage = try await viewModel.fetchProfilePhoto(for: appUser)
                            await MainActor.run {
                              profileImage = Image(uiImage: uiImage)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView(appUser: .constant(.init(uid: "", email: "")))
    }
}
