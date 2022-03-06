//
//  SharedFunctionsAndConstants.swift
//  FurryFriends
//
//  Created by Nicole on 2022/3/6.
//

import Foundation

func getDocumentsDirectory() -> URL {
    
    let paths = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
  
    //Return the first path
    return paths[0]
}

let savedFavoritesLable = "savedFavotires"
