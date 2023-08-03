//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Uhl Albert on 8/3/23.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

final class ExtensionTests: BaseTestCase {
    func testIssueTitleUnwrap() {
        let issue = Issue(context: managedObjectContext)

        issue.title = "Example issue"
        XCTAssertEqual(issue.issueTitle, "Example issue", "Changing title should also change issueTitle.")

        issue.issueTitle = "Updated issue"
        XCTAssertEqual(issue.title, "Updated issue", "Changing issueTitle should also change title.")
    }

    func testIssueContentUnwrap() {
        let issue = Issue(context: managedObjectContext)

        issue.content = "Example issue"
        XCTAssertEqual(issue.issueContent, "Example issue", "Changing content should also change issueContent.")

        issue.issueContent = "Updated issue"
        XCTAssertEqual(issue.content, "Updated issue", "Changing issueContent should also change title.")
    }

    func testIssueCreationDateUnwrap() {
        // Given
        let issue = Issue(context: managedObjectContext)
        let testDate = Date.now

        // When
        issue.creationDate = testDate

        // Then
        XCTAssertEqual(issue.issueCreationDate, testDate, "Changing creationDate should also change issueCreationDate.")
    }

    func testIssueTagsUnwrap() {
        let tag = Tag(context: managedObjectContext)
        let issue = Issue(context: managedObjectContext)

        XCTAssertEqual(issue.issueTags.count, 0, "A new issue should have no tags.")

        issue.addToTags(tag)
        XCTAssertEqual(issue.issueTags.count, 1, "Adding 1 tag to an issue should result in issueTags having count 1.")
    }

    func testIssueTagsList() {
        let tag = Tag(context: managedObjectContext)
        let issue = Issue(context: managedObjectContext)

        tag.name = "My Tag"
        issue.addToTags(tag)

        XCTAssertEqual(issue.issueTagsList, "My Tag", "Adding 1 tag to an issue should make issueTagsList be My Tag")
    }

    func testIssueSortingIsStable() {
        let issue1 = Issue(context: managedObjectContext)
        issue1.title = "B Issue"
        issue1.creationDate = .now

        let issue2 = Issue(context: managedObjectContext)
        issue2.title = "B Issue"
        issue2.creationDate = .now.addingTimeInterval(1)

        let issue3 = Issue(context: managedObjectContext)
        issue3.title = "A Issue"
        issue3.creationDate = .now.addingTimeInterval(100)

        let allIssues = [issue1, issue2, issue3]
        let sorted = allIssues.sorted()

        XCTAssertEqual([issue3, issue1, issue2], sorted, "Sorting issue arrays should use name then creation date.")
    }

    func testTagIDUnwrap() {
        let tag = Tag(context: managedObjectContext)

        tag.id = UUID()
        XCTAssertEqual(tag.tagID, tag.id, "Changing id should also change tagID.")
    }

    func testTagNameUnwrap() {
        let tag = Tag(context: managedObjectContext)

        tag.name = "Example Tag"
        XCTAssertEqual(tag.tagName, "Example Tag", "Changing name should also change tagName.")
    }

    func testTagActiveIssues() {
        let tag = Tag(context: managedObjectContext)
        let issue = Issue(context: managedObjectContext)

        XCTAssertEqual(tag.tagActiveIssues.count, 0, "A new tag should have 0 active issues.")

        tag.addToIssues(issue)
        XCTAssertEqual(tag.tagActiveIssues.count, 1, "A new tag with 1 new issue should have 1 active issue.")

        issue.completed = true
        XCTAssertEqual(tag.tagActiveIssues.count, 0, "A new tag with 1 completed issue should have 1 active issue.")
    }

    func testTagSortingIsStable() {
        let tag1 = Tag(context: managedObjectContext)
        tag1.name = "B Tag"
        tag1.id = UUID()

        let tag2 = Tag(context: managedObjectContext)
        tag2.name = "B Tag"
        tag2.id = UUID(uuidString: "FFFFFFFF-BCE4-4BCE-AFEC-CE401DDD91EF")

        let tag3 = Tag(context: managedObjectContext)
        tag3.name = "A Tag"
        tag3.id = UUID()

        let allTags = [tag1, tag2, tag3]
        let sortedTags = allTags.sorted()

        XCTAssertEqual([tag3, tag1, tag2], sortedTags, "Sorting tag array should use name then UUID string.")
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        XCTAssertEqual(data, "Never ask a starfish for directions.", "The string must match DecodableString.json")
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)
        XCTAssertEqual(data.count, 3, "There should be 3 items decoded from DecodableDictionary.json")
        XCTAssertEqual(data["One"], 1, "The dictionary should contain the value 1 for the key One.")
    }
}
