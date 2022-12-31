//
//  HomeView.swift
//  Vlog
//
//  Created by Christopher James on 29/09/2022.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach($viewModel.blogsList.wrappedValue.indices, id: \.self) { index in
                        let item = viewModel.blogsList[index]
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 1)
                                    .frame(width: 400, height: 120, alignment: .center)
                                    .foregroundColor(.white)
                                VStack {
                                    HStack {
                                        Image(uiImage: item.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .padding()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .fontWeight(.bold)
                                                .font(.system(size: 21, weight: .medium,design: .default))
                                            Text(item.date)
                                        }
                                    }
                                }
                            }
                            if (self.viewModel.user.profile == .admin) {
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        self.viewModel.deleteBlog(blog: item)
                                    }
                            }
                        }.onTapGesture {$viewModel.isBlogPresented.wrappedValue.toggle()}
                        .fullScreenCover(isPresented: self.$viewModel.isBlogPresented, content: {BlogView(viewModel: viewModel, blog: item)})
                    }.listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .toolbar{
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {}) {
                            Image(systemName: "book")
                        }.disabled($viewModel.isPopUpBlogPresented.wrappedValue)
                        Button(action: {self.viewModel.deconnexion()}) {
                            Image(systemName: "gear")
                        }.disabled($viewModel.isPopUpBlogPresented.wrappedValue)
                    }
                    if (self.viewModel.user.profile == .admin) {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {$viewModel.isPopUpBlogPresented.wrappedValue.toggle()}) {
                                Image(systemName: "plus.app")
                            }.disabled($viewModel.isPopUpBlogPresented.wrappedValue)
                        }
                    }
                }
                if ($viewModel.isPopUpBlogPresented.wrappedValue) {
                    PopUpBlog(viewModel: viewModel)
                }
            }.navigationTitle("Mes blogs")
            .alert(isPresented: self.$viewModel.isAlertpresented, content: {Alert(title: Text(self.$viewModel.alertMessage.wrappedValue))})
        }.onAppear{self.viewModel.fetchBlog()}
    }
}

struct PopUpBlog: View {
    
    @State var isPickerShowing = false
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: HorizontalAlignment.center, spacing: 10) {
                    Text("Nouveau blog")
                        .font(.title)
                        .foregroundColor(.black)
                    Divider()
                    Text("Titre")
                        .font(.title)
                        .foregroundColor(.black)
                    TextField("Titre", text: $viewModel.newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .frame(width: 300)
                    Text("Image de preview")
                        .font(.title)
                        .foregroundColor(.black)
                    if ($viewModel.selectedImage.wrappedValue != nil) {
                        Image(uiImage: $viewModel.selectedImage.wrappedValue!)
                            .resizable()
                            .frame(width: 300, height: 300)
                    }
                    Button(action: {self.isPickerShowing = true}) {
                        Text("Sélectionner une photo")
                    }.sheet(isPresented: $isPickerShowing, onDismiss: nil) {ImagePicker(selectedImage: $viewModel.selectedImage, isPickerShowing: $isPickerShowing)}
                    Divider()
                    
                    HStack(spacing: 40) {
                        Button(action: {self.viewModel.addNewBlog()}) {
                            RoundTextButton(text: "Valider", color: .green)
                        }.disabled($viewModel.newTitle.wrappedValue == "" || $viewModel.selectedImage.wrappedValue == nil)
                        Button(action: {}) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Button(action: {self.$viewModel.isPopUpBlogPresented.wrappedValue = false}) {
                            RoundTextButton(text: "Annuler", color: .red)
                        }
                    }.padding()
                }.frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(30)
            }.padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.black.opacity(0.5))
        }
    }
}

struct BlogView: View {
    
    @StateObject var viewModel: HomeViewModel
    @State var blog: Blog
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .leading) {
                        Text(blog.title).bold()
                        Text(blog.date)
                        Image(uiImage: blog.image)
                            .resizable()
                        Text(blog.textContent)
                    }.padding(20)
                }.toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {$viewModel.isBlogPresented.wrappedValue.toggle()}) {
                            Image(systemName: "arrowshape.turn.up.backward")
                        }
                    }
                }
            }
        }
    }
    
}

