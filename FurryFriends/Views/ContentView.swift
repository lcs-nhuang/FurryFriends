//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentLeftImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentRightImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentDogImage: DogImage = DogImage(message: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png",
                                                    status: "success")
    
    @State var currentCatImage: CatImage = CatImage(file: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")
    
    @State var favoritesCat: [CatImage] = []
    
    @State var favoritesDog: [DogImage] = []
    
    @State var currentCatAddedToFavorites: Bool = false
    
    @State var currentDogAddedToFavorites: Bool = false
    
    
    @State private var progressDog = 0.0
    
    @State private var progressCat = 0.0
    
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            HStack{
                
                VStack{
                    RemoteImageView(fromURL: currentLeftImage)
                    
                    HStack{
                    Button(action: {
                        
                        progressDog += 0.125
                        
                        Task{
                            await loadNewDog()
                        }
                        
                        Task{
                            await loadNewCat()
                        }
                        
                    },
                           label: {
                        Image("DogBotton")
                            .resizable()
                            .frame(width: 60, height: 50)
                    })
                    
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .padding(10)
                            .onTapGesture{
                                if currentDogAddedToFavorites == false{
                                    favoritesDog.append(currentDogImage)
                                    
                                    currentDogAddedToFavorites = true
                                }}
                           
                    }
                }
                
                
                Text("VS")
                    .bold()
                
                
                VStack{
                    RemoteImageView(fromURL: currentRightImage)
                    
                    
                    HStack{
                    Button(action: {
                        progressCat += 0.125
                        
                        Task{
                            await loadNewCat()
                        }
                        
                        Task{
                            await loadNewDog()
                        }
                        
                    },
                           label: {
                        Image("CatBotton")
                            .resizable()
                            .frame(width: 60, height: 50)
                    })
                    
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .padding(10)
                            .onTapGesture{
                                if currentCatAddedToFavorites == false{
                                    favoritesCat.append(currentCatImage)
                                    
                                    currentCatAddedToFavorites = true
                                }}
                    }
                    
                    
                }
                
            }
            .padding()
            
            HStack{
            ProgressView(value: progressDog)
                    .tint(.brown)
                .padding()
            
            ProgressView(value: progressCat)
                .tint(.orange)
                .padding()
            }
            
            HStack{
                Text("Dog or Cat")
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
            }
            
            
            List(favoritesDog, id: \.self) { currentFavoriteDog in
                RemoteImageView(fromURL: currentLeftImage)
            }
            
            
            
            
            // Push main image to top of screen
            Spacer()
            
        }
        // Runs once when the app is opened
        .task {
            
            // Example images for each type of pet
            let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
            let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
            
            await loadNewDog()
            
            await loadNewCat()
            
            // Replaces the transparent pixel image with an actual image of an animal
            // Adjust according to your preference ☺️
            currentLeftImage = URL(string: currentDogImage.message)!
            
            currentRightImage = URL(string: currentCatImage.file)!
            
        }
        .navigationTitle("Furry Friends")
        
    }
    
    
    
    // MARK: Functions
    
    func loadNewDog() async{
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        do {
            
            let (data, _) = try await urlSession.data(for: request)
            
            currentDogImage = try JSONDecoder().decode(DogImage.self, from: data)
            
            currentDogAddedToFavorites = false
            
            currentLeftImage = URL(string: currentDogImage.message)!
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            
            print(error)
        }
        
    }
    
    
    
    func loadNewCat() async{
        let url = URL(string: "https://aws.random.cat/meow")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        do {
            
            let (data, _) = try await urlSession.data(for: request)
            
            currentCatImage = try JSONDecoder().decode(CatImage.self, from: data)
            
            currentCatAddedToFavorites = false
            
            currentRightImage = URL(string: currentCatImage.file)!
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            
            print(error)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
