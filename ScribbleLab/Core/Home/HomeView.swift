//
//  HomeView.swift
//  ScribbleLab
//
//  Created by Nevio Hirani on 07.10.23.
//

import SwiftUI
import TipKit
import UserNotifications

struct HomeView: View {
    @StateObject var viewModifier = HomeViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // [START dev_properties_test]
    @State private var documentsAvailable = false
    // [END dev_properties_test]
     
    // [START create_shared_instance_of_tip]
    let createFirstDocumentTip = CreateNewDocumentTip()
    let showNotificationTip = ShowNotificationsTip()
    // [END create_shared_instance_of_tip]
        
    var body: some View {
        NavigationStack {
            VStack {
                if documentsAvailable == true {
                    Text("Hi")
                } else {
                    ContentUnavailableView("You have no documents", systemImage: "doc.viewfinder.fill")
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await CreateNewDocumentTip.createNewDocumentEvent.donate() }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popoverTip(createFirstDocumentTip)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { /* TODO: Store tip */ }
                    } label: {
                        Image(systemName: "storefront")
                    }
                    /* .popoverTip(createFirstDocumentTip) */
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModifier.notificationSheetisPresented.toggle()
                        Task {
                            await ShowNotificationsTip.visitNotificationViewEvent.donate()
                        }
                        viewModifier.newNotification.toggle()
                    } label: {
                        Image(systemName: viewModifier.newNotification ? "bell.badge" : "bell")
                    }
                    .popoverTip(showNotificationTip)
                    .sheet(isPresented: $viewModifier.notificationSheetisPresented, content: {
                        NotificationSheetView()
                    })
                }
                
                // FIXME: TODO: Show Settings sheet
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModifier.settingsViewSheetisPresented.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .sheet(isPresented: $viewModifier.settingsViewSheetisPresented, content: {
                        SLSettingsView()
                    })
                }
            }
            .tint(isDarkMode ? .white : .black)
        }
        
        // FIXME: Fix notification alert
        .onAppear {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge, .provisional, .criticalAlert]) { granted, error in
                
                if let error = error {
                    // Handle the error here.
                    print("DEBUG:\(error.localizedDescription).")
                }
                
                // FIXME: Rework this
                if granted == granted {
                    self.viewModifier.allowNotificationsIsGarnted.toggle()
                }
                // Provisional authorization granted.
            }
            
            Task {
                await CreateNewDocumentTip.launchHomeScreenEvent.donate()
            }
            
            Task {
                await ShowNotificationsTip.launchHomeScreenEvent.donate()
            }
        }
    }
}

#Preview {
    HomeView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
