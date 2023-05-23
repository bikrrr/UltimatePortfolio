//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by Uhl Albert on 4/12/23.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?

    var activeIssuesCount: Int {
        tag?.tagActiveIssues.count ?? 0
    }

    static var all = Filter(
        id: UUID(),
        name: "All issues",
        icon: "tray"
    )

    static var recent = Filter(
        id: UUID(),
        name: "Recent issues",
        icon: "clock",
        minModificationDate: .now.addingTimeInterval(86400 * -7)
    )

    func has(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
