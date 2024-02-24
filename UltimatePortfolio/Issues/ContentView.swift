//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Uhl Albert on 4/11/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var viewModel: ViewModel

    var body: some View {
        List(selection: $viewModel.selectedIssue) {
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Issues")
        .searchable(
            text: $viewModel.filterText,
            tokens: $viewModel.filterTokens,
            prompt: "Filter issues or type # to add tags") { tag in
                Text(tag.tagName)
        }
        .searchSuggestions {
            ForEach(viewModel.dataController.suggestedFilterTokens) { token in
                Button {
                    viewModel.dataController.filterTokens.append(token)
                    viewModel.filterText = ""
                } label: {
                    Text(token.tagName)
                }
            }
        }
        .toolbar(content: ContentViewToolbar.init)
        .onAppear(perform: askForReview)
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataController: .preview)
    }
}
