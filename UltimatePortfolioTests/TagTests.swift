//
//  TagTests.swift
//  UltimatePortfolioTests
//
//  Created by Uhl Albert on 8/3/23.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

final class TagTests: BaseTestCase {
    func testCreatingTagsAndIssues() {
        let count = 10
        let issueCount = 10 * 10

        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<count {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
        }

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), issueCount, "Expected \(issueCount) issues.")
    }

    func testDeletingTagDoesNotDeleteIssues() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)
        dataController.delete(tags[0])

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "Expected 50 issues after deleting a tag.")
    }
}
