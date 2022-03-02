//
//  FavoriteButtonView.swift
//  FurryFriends
//
//  Created by Nicole on 2022/3/2.
//

import SwiftUI

struct FavoriteButtonView: View {
    
    @State var currentDogAddedToFavorites: Bool = false
    
    @State var favoritesDog: [DogImage] = []
    
    @State var currentDogImage: DogImage = DogImage(message: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png",
                                                    status: "success")
    
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

struct FavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButtonView()
    }
}
