//
//  StoreView.swift
//  UltimatePortfolio
//
//  Created by Uhl Albert on 2/23/24.
//

import StoreKit
import SwiftUI

struct StoreView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var products = [Product]()

    var body: some View {
        NavigationStack {
            if let product = products.first {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(.title)

                    Text(product.description)

                    Button("Buy Now") {
                        purchase(product)
                    }
                }
            }
        }
        .onChange(of: dataController.fullVersionUnlocked) { _ in
            checkForPurchase()
        }
        .task {
            await load()
        }
    }

    func checkForPurchase() {
        if dataController.fullVersionUnlocked {
            dismiss()
        }
    }

    func purchase(_ product: Product) {
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }

    func load() async {
        do {
            products = try await Product.products(for: [DataController.unlockPremiumProductID])
        } catch {
            print("Failed to load products: \(error.localizedDescription)")
        }
    }
}

#Preview {
    StoreView()
}
