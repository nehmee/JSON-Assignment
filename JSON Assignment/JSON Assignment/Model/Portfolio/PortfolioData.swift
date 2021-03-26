//
//  Portfolio.swift
//  JSON Assignment
//
//  Created by Mohamad Nehme on 23/03/2021.
//

import Foundation
struct PortfolioData: Codable {
    let name: String
    let balance: Int
    let id: String
    let created_at: String
    let investment_type: String
}
