//
//  ObjectManager.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation
import SwiftUI

class ObjectManager<T: Identifiable & Codable>: ObservableObject {
    @Published var objects: [T]
    
    var location: FileManagerUtil.FileLocation
    var onAction: ((ObjectManagerAction<T>) -> ())? = nil

    init(location: FileManagerUtil.FileLocation) {
        self.objects = []
        self.location = location
        load()
    }
    
    func update(_ object: T) {
        guard let index = objects.firstIndex(where: {$0.id == object.id}) else {
            return
        }
        objects[index] = object
        onAction?(.update(object))
        cache()
    }
    
    func add(_ object: T) {
        objects.append(object)
        onAction?(.add(object))
        cache()
    }
    
    func remove(_ object: T) {
        guard let index = objects.firstIndex(where: {$0.id == object.id}) else {
            return
        }
        objects.remove(at: index)
        onAction?(.remove(object))
        cache()
    }

    func cache() {
        do {
            guard let fileUrl = FileManagerUtil.getDirectory(location: location) else {
                return
            }
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(objects)
            try encodedData.write(to: fileUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() {
        do {
            let decoder = JSONDecoder()
            guard let fileUrl = FileManagerUtil.getDirectory(location: location) else {
                return
            }
            let data = try Data(contentsOf: fileUrl)
            let objects = try decoder.decode([T].self, from: data)
            self.objects = objects
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func nukeLocal() {
        objects = []
        cache()
    }
    
    /**
        User this wheny you fetch from a remote server, and need to set and store objects locally. This wont call the onAction completion handler that is used to push changes to remote. Doing this prevents uploaind data that is already present on the back end.
     */
    func addLocally(_ object: T) {
        objects.append(object)
        cache()
    }
    
    /**
        This will set data for local storage, but will not call the delegate function for added data to be uploaded to the backend.
     */
    func setLocally(_ objects: [T]) {
        self.objects = objects
        cache()
    }
}

enum ObjectManagerAction<T: Identifiable & Codable> {
    case add(T)
    case remove(T)
    case update(T)
}
