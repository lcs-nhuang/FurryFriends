//
//  FavoriteCatButtonView.swift
//  FurryFriends
//
//  Created by Nicole on 2022/3/4.
//


import SwiftUI

struct FavoriteCatButtonView: View {
    
    @Binding var currentCatAddedToFavorites: Bool
    
    @Binding var favoritesCat: [CatImage]
    
    @Binding var currentCatImage: CatImage
    
    
    
    var body: some View {
        ZStack{
        Image(systemName: "star")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(.blue)
            .padding(10)
            .opacity(currentCatAddedToFavorites == true ? 0.0 : 1.0)
            .onTapGesture{
                if currentCatAddedToFavorites == false{
                    favoritesCat.append(currentCatImage)
                    
                    currentCatAddedToFavorites = true
                }}
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
                .padding(10)
                .opacity(currentCatAddedToFavorites == true ? 1.0 : 0.0)
        }
    }
}



