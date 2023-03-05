//
//  Model.swift
//  collectionview-movie
//
//  Created by Burak Kubat on 23.02.2023.
//

import Foundation




struct Movies: Decodable{
    let results: [Result]
}
struct Result: Decodable{
    let title: String
    let overview: String
    let poster_path: String
    let backdrop_path: String
}


