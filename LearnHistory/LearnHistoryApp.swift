//
//  LearnHistoryApp.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-04.
//
import CoreData
import SwiftUI
import WikipediaKit
@main
struct LearnHistoryApp: App {
    @StateObject private var dataController = DataController()
    init(){
        WikipediaNetworking.appAuthorEmailForAPI = "nmartin1956@gmail.com"
    }
    var alreadyAppeared = false
    var body: some Scene {
        WindowGroup {
                ZStack {
                    NMLogo()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                    
                }
        }

        

        
    }
}
