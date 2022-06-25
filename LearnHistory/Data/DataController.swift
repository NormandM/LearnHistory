//
//  DataController.swift
//  TestSwiftUICoreData
//
//  Created by Normand Martin on 2022-03-04.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HistoricalEvent")
    init() {
        container.loadPersistentStores {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
