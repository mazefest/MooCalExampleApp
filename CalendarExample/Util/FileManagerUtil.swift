//
//  FileManagerUtil.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation

class FileManagerUtil {
    enum FileLocation: String {
        case events
    }
    
    static var baseUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func getDirectory(location: FileLocation) -> URL? {
        return baseUrl.appending(component: location.rawValue)
    }
    
    static func deleteFile(location: FileLocation) {
        let url = baseUrl.appending(component: location.rawValue)
        try? FileManager.default.removeItem(at: url)
    }
    
    static func save<T: Codable>(object: T, location: FileLocation) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            guard let url = getDirectory(location: location) else {
                return
            }
            print(url)
            
            try data.write(to: url)
        } catch {
            print(">>>>> \(error.localizedDescription)")
        }
    }
    
    static func load<T: Codable>(type: T.Type, location: FileLocation, completion: @escaping (T?)->()) {
        let decoder = JSONDecoder()
        guard let url = FileManagerUtil.getDirectory(location: location),
              let data = try? Data(contentsOf: url),
              let decodedData = try? decoder.decode(T.self, from: data) else {
            completion(nil)
            return
        }
        completion(decodedData)
    }
    
    static func load<T: Codable>(type: T.Type, location: FileLocation) -> T? {
        let decoder = JSONDecoder()
        do {
            guard let url = FileManagerUtil.getDirectory(location: location) else {
                print("can't get url")
                return nil
            }
            let data = try Data(contentsOf: url)
            let decodedData = try? decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
            
        }
    }
    
}
