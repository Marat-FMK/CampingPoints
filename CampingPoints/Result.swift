//
//  Result.swift
//  CampingPoints
//
//  Created by Marat Fakhrizhanov on 09.11.2024.
//

import Foundation

enum LoadingState {
    case loading, loaded, failed
}

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String { // геттер возвращает описание  если оно есть в необязательном массиве // если сервер нам не дает описание - пишем но фатуре...
        
        terms?["description"]?.first ?? "No further information"// ищем по ключу
    }
    static func <(lhs: Page, rhs:Page) -> Bool {
        lhs.title < rhs.title
    }
}
