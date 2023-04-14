//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Uhl Albert on 4/11/23.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) {
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
