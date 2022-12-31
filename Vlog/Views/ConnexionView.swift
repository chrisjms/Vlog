//
//  ContentView.swift
//  Vlog
//
//  Created by Christopher James on 25/09/2022.
//

import SwiftUI

struct ConnexionView: View {
    @StateObject var viewModel = ConnexionViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Image("mountains")
                    .resizable()
                    .frame(height: 550)
                Divider()
                ZoneConnexion(viewModel: viewModel)
            }
        }}
}

struct ZoneConnexion: View {
    @StateObject var viewModel = ConnexionViewModel()
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(Color.black.opacity(0.9))
                .frame(height: 450)
            VStack(spacing: 25) {
                Text("Se connecter")
                    .foregroundColor(Color.white)
                    .font(.title)
                TextField("Email", text: $viewModel.user.mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1)
                    .disableAutocorrection(true)
                    .frame(width: 300)
                SecureField("Mot de passe", text: $viewModel.user.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1)
                    .disableAutocorrection(true)
                    .frame(width: 300)
                    .textContentType(.password)
                Button(action: {viewModel.logIn(mail: self.viewModel.user.mail, password: self.viewModel.user.password)}) {
                    RoundTextButton(text: "Connexion", color: .blue)
                }.sheet(isPresented: self.$viewModel.isSubscriptionPresented, content: {sheetSubscription(viewModel: viewModel).presentationDetents([.large, .fraction(0.45)])})
                Text("Pas encore inscrit?")
                    .foregroundColor(Color.white)
                Button(action: {self.viewModel.isRegistrationPresented.toggle()}) {
                    RoundTextButton(text: "S'inscrire", color: .blue)
                }.sheet(isPresented: self.$viewModel.isRegistrationPresented, content: {sheetRegistration(viewModel: viewModel)
                        .presentationDetents([.large, .fraction(0.45)])
                })
                .padding(.bottom, 80)
            }
        }.fullScreenCover(isPresented: self.$viewModel.goToHome, content: {HomeView(viewModel: HomeViewModel(currentUser: self.viewModel.user))})
            .alert(isPresented: self.$viewModel.isAlertpresented, content: {Alert(title: Text(self.$viewModel.alertMessage.wrappedValue))})
    }
}

struct sheetRegistration: View {
    @StateObject var viewModel = ConnexionViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Créer un compte")
                        .font(.title)
                        .foregroundColor(.black)
                    HStack {
                        Text("Déjà inscris?")
                        Button(action: {self.viewModel.isRegistrationPresented.toggle()}) {
                            Text("Se connecter")
                                .foregroundColor(.blue.opacity(0.8))
                        }
                    }
                    TextField("Prénom", text: $viewModel.newUserFirstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1)
                        .disableAutocorrection(true)
                        .frame(width: 300)
                    TextField("Nom", text: $viewModel.newUserLastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1)
                        .disableAutocorrection(true)
                        .frame(width: 300)
                    TextField("Adresse email", text: $viewModel.newMail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1)
                        .disableAutocorrection(true)
                        .frame(width: 300)
                    SecureField("Mot de passe", text: $viewModel.newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1)
                        .disableAutocorrection(true)
                        .frame(width: 300)
                        .textContentType(.password)
                    Button(action: {viewModel.signUp(newMail:$viewModel.newMail.wrappedValue, newPassword:$viewModel.newPassword.wrappedValue)}) {
                        RoundTextButton(text: "S'inscrire", color: .blue)
                    }
                }
            }
        }.alert(isPresented: self.$viewModel.isAlertpresented, content: {Alert(title: Text(self.$viewModel.alertMessage.wrappedValue))})
    }
}

struct sheetSubscription: View {
    @StateObject var viewModel = ConnexionViewModel()
    var body: some View {
        NavigationView {
            ZStack() {
                Color.orange.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Bienvenue \($viewModel.user.firstName.wrappedValue)")
                        .font(.title)
                        .foregroundColor(.black)
                    Text("Souscrire à l'abonnement")
                        .foregroundColor(.black)
                    HStack {
                        Button(action: {}) {
                            RoundTextButton(text: "15€/mois", color: .blue)
                        }
                        Button(action: {}) {
                            RoundTextButton(text: "Accéder", color: .blue)
                        }.disabled(true)
                    }
                    Text("Ou")
                        .foregroundColor(.black)
                    Button(action: {self.viewModel.isSubscriptionPresented.toggle()}) {
                        Text("Revenir à la page de connexion")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}

