//
//  ContentView.swift
//  Alice Pheulpin
//
//  Created by Christopher James on 25/09/2022.
//

import SwiftUI

struct ConnexionView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Image("AliceConnexion")
                        .resizable()
                        .frame(height: 550)
                    VStack{
                        Text("Alice Pheulpin")
                            .foregroundColor(Color.white)
                        Text("Ton coaching sportif")
                            .foregroundColor(Color.red)
                    }
                }
                ZoneSubscribe()
            }
        }}
}

struct ZoneSubscribe: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(height: 410)
            VStack(alignment: .center) {
                Text("Souscrire maintenant pour avoir accès à tous mes contenus")
                    .foregroundColor(Color.white)
                Button(action: {}) {
                    RoundTextButton(text: "Souscrire pour seulement 10€ / mois", color: Color.green)
                }
                Text("Abonnement résiliable à tout moment. Automatiquement renouvelé et facturé chaque mois.")
                    .foregroundColor(Color.white)
                Button(action: {}) {
                    RoundTextButton(text: "Aperçu sans abonnement", color: Color.black)
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
