//
//  FavoriteButtonView.swift
//  FurryFriends
//
//  Created by Nicole on 2022/3/2.
//

import SwiftUI

struct FavoriteDogButtonView: View {
    
    @Binding var currentDogAddedToFavorites: Bool
    
    @Binding var favoritesDog: [DogImage]
    
    @Binding var currentDogImage: DogImage
    
    
    
    var body: some View {
        ZStack{
        Image(systemName: "star")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(.blue)
            .padding(10)
            .opacity(currentDogAddedToFavorites == true ? 0.0 : 1.0)
            .onTapGesture{
                if currentDogAddedToFavorites == false{
                    favoritesDog.append(currentDogImage)
                    
                    currentDogAddedToFavorites = true
                }}
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
                .padding(10)
                .opacity(currentDogAddedToFavorites == true ? 1.0 : 0.0)
        }
    }
}

//struct FavoriteButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteDogButtonView(currentDogAddedToFavorites: .constant(false), favoritesDog: [] , currentDogImage: )
//    }
//}
