//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    @Environment(\.scenePhase) var scenePhase
    
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
        
        ZStack{
            
            
            VStack {
                
                HStack{
                    
                    VStack{
                        // Shows the main image
                        RemoteImageView(fromURL: currentLeftImage)
                        
                        HStack{
                            Button(action: {
                                
                                progressDog += 1.25
                                
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
                            
                            
                            FavoriteDogButtonView(currentDogAddedToFavorites: $currentDogAddedToFavorites, favoritesDog: $favoritesDog, currentDogImage: $currentDogImage)
                            
                        }
                    }
                    
                    
                    Text("VS")
                        .bold()
                    
                    
                    VStack{
                        RemoteImageView(fromURL: currentRightImage)
                        
                        
                        HStack{
                            Button(action: {
                                progressCat += 1.25
                                
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
                                    .frame(width: 54, height: 45)
                            })
                            
                            FavoriteCatButtonView(currentCatAddedToFavorites: $currentCatAddedToFavorites, favoritesCat: $favoritesCat, currentCatImage: $currentCatImage)
                        }
                        
                        
                    }
                    
                }
                .padding()
                
                HStack{
                    ProgressView(value: progressDog,total: 10)
                        .tint(.brown)
                        .padding()
                    
                    ProgressView(value: progressCat,total: 10)
                        .tint(.orange)
                        .padding()
                }
                
                HStack{
                    Text("Favorites")
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                }
                
                HStack{
                    Text("Dog")
                        .bold()
                    
                    Spacer()
                        .frame(width: 200)
                    
                    Text("Cat")
                        .bold()
                    
                    
                }
                
                HStack{
                    List(favoritesDog, id: \.self) {
                        
                        currentFavoriteDog in
                        RemoteImageView(fromURL: URL(string: currentFavoriteDog.message)!)
                    }
                    
                    List(favoritesCat, id: \.self) { currentFavoriteCat in
                        RemoteImageView(fromURL: URL(string: currentFavoriteCat.file)!)
                    }
                    
                }
                
                
                
                
                // Push main image to top of screen
                Spacer()
                
            }
            
           
                
            LottieView(animationNamed: "69484-relax")
                .opacity(progressDog == 10 ? 1.0 : 0.0 )
            
            LottieView(animationNamed: "48205-cats-in-a-box")
                .opacity(progressCat == 10 ? 1.0 : 0.0)
            
            
            Button(action: {
                progressDog = 0
                
                progressCat = 0
            }, label: {
                Text("Again!")
            })
                .font(.largeTitle)
                .padding(.top, 300)
                .opacity(progressDog == 10 || progressCat == 10 ? 1.0 : 0.0)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                
                
               

            
                .onChange(of: scenePhase) { newPhase in
                    
                    if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .active {
                        print("Active")
                    } else if newPhase == .background {
                        print("Background")
                        
                        persistFavoritesDog()
                        
                        persistFavoritesCat()
                    }
                    
                }
            
            
            
            // Runs once when the app is opened
                .task {
                    
                    await loadNewDog()
                    
                    await loadNewCat()
                    
                    
                    currentLeftImage = URL(string: currentDogImage.message)!
                    
                    currentRightImage = URL(string: currentCatImage.file)!
                    
                }
                .navigationTitle("Furry Friends")
            
        }
        
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
    
    
    func persistFavoritesDog() {
        
        // Get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavoritesLable)
        print(filename)
        
        do {
            //Create a JSON Encoder object
            let encoder = JSONEncoder()
            
            //Configured the encoder to "Pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of favorite dog we've collect
            let data = try encoder.encode(favoritesDog)
            
            //Write the JSON to a file in the filename location we came up with earlier
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //See the data that was written
            print("Saved data to the Documents directy succeddfully")
            print("========")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            print("Unable to write list of favorite to the Documents directoty")
            print("=========")
            print(error.localizedDescription)
        }
        
    }
    
    
    func persistFavoritesCat() {
        
        // Get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavoritesLable)
        print(filename)
        
        do {
            //Create a JSON Encoder object
            let encoder = JSONEncoder()
            
            //Configured the encoder to "Pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of favorite cat we've collect
            let data = try encoder.encode(favoritesCat)
            
            //Write the JSON to a file in the filename location we came up with earlier
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //See the data that was written
            print("Saved data to the Documents directy succeddfully")
            print("========")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            print("Unable to write list of favorite to the Documents directoty")
            print("=========")
            print(error.localizedDescription)
        }
        
    }
    
    
    func loadFavouritesDog() {
        
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavoritesLable)
        print(filename)
        
        //Attempt to load the data
        do {
            
            // Load the raw data
            let data = try Data(contentsOf: filename)
            
            //See the data that was read
            print("Saved data to the Documents directy succeddfully")
            print("========")
            print(String(data: data, encoding: .utf8)!)
            
            //Decode the JSON into Swift native data structures
            favoritesDog = try JSONDecoder().decode([DogImage].self, from: data)
            
            
            
        } catch  {
            //What went wrong?
            print("Could not load the data from the stored JSON file")
            print("========")
            print(error.localizedDescription )
        }
    }
    
    
    func loadFavouritesCat() {
        
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavoritesLable)
        print(filename)
        
        //Attempt to load the data
        do {
            
            // Load the raw data
            let data = try Data(contentsOf: filename)
            
            //See the data that was read
            print("Saved data to the Documents directy succeddfully")
            print("========")
            print(String(data: data, encoding: .utf8)!)
            
            //Decode the JSON into Swift native data structures
            favoritesCat = try JSONDecoder().decode([CatImage].self, from: data)
            
            
            
        } catch  {
            //What went wrong?
            print("Could not load the data from the stored JSON file")
            print("========")
            print(error.localizedDescription )
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
