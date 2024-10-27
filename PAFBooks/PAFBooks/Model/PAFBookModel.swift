//
//  PAFBookModel.swift
//  PAFBooks
//
//  Created by silasi on 27/10/24.
//

import Foundation

struct PAFBook: Codable, Identifiable {
    let id: String
    let title: String
    let language: String
    let thumbnail: PAFThumbnail
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
    let description: String
    
    struct PAFThumbnail: Codable {
        let id: String
        let version: Int
        let domain: String
        let basePath: String
        let key: String
    }
}
