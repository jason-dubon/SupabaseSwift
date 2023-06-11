//
//  ToDoItemView.swift
//  SupabaseAuth
//
//  Created by Jason Dubon on 5/31/23.
//

import SwiftUI

struct ToDoItemView: View {
    @EnvironmentObject var viewModel: ToDoViewModel
    @State var todo: ToDo
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack {
                Color.red
                
                Spacer()
                
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .trailing)
                    .padding(.trailing, 20)
            }
            .background(.red)
            .onTapGesture {
                Task {
                    do {
                        try await viewModel.deleteItem(todo: todo)
                    } catch {
                        print("error deleting item")
                        print(error)
                    }
                }
            }
            
            ZStack {
                Color(red: 62/255, green: 207/255, blue: 142/255)
                    .offset(x: offset)
                
                HStack {
                    Text(todo.text)
                        .foregroundColor(Color(red: 39/255, green: 40/255, blue: 39/255))
                        .padding()
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 62/255, green: 207/255, blue: 142/255), lineWidth: 4)
                    .shadow(color: Color(red: 39/255, green: 40/255, blue: 39/255), radius: 10)
            )
            
        }
        .frame(height: 80)
        .cornerRadius(20)
        .gesture(
            DragGesture()
                .onChanged(onChange(value:))
        )
    }
    
    func onChange(value: DragGesture.Value) {
        if value.translation.width < 0 {
            offset = -75
        } else {
            offset = 0
        }
    }
    
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(todo: .init(id: 0, createdAt: "", text: "Homework", userUid: ""))
            .environmentObject(ToDoViewModel())
    }
}
