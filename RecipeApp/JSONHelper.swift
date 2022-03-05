//
//  JSONHelper.swift
//  Track_MVI
//
//  Created by Nicolas Bofi on 17/02/2022.
//

import Foundation

struct JSONHelper{
    static var urlBase = "https://nicolas-ig.alwaysdata.net/api/"
    
    static func loadFromFile(name: String, fileExtension: String) -> Data? {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: fileExtension){ // paramètres de type String
            if let content = try? Data(contentsOf: fileURL) { // donnée de type Data (buffer d'octets)
                return content
            }
        }
        return nil
    }
    
    static func decode<T: Decodable>(data: Data) -> T?{
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: data) { // si on a réussit à décoder
            return decoded
        }
        return nil
    }
    
    static func encode<T: Encodable>(data: T) async -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
    
    //    static func encode<T: Encodable>(data: T, name: String, fileExtension: String) -> Bool{
    //        let encoder = JSONEncoder()
    //        encoder.outputFormatting = .prettyPrinted
    //        let json = try? encoder.encode(data)
    //        guard let jsonData = json else {return false}
    //        if let fileURL = Bundle.main.url(forResource: name, withExtension: fileExtension) {
    //
    //            do{
    //                try jsonData.write(to: URL(fileURLWithPath: fileURL.relativePath))
    //            } catch {
    //                print("Erreur : " + error.localizedDescription)
    //            }
    //            return true
    //        }
    //        return false
    //    }
    
    static func get<T:Decodable>(url: String) async -> Result<T, JSONError>{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let (data, _) =
                try? await URLSession.shared.data(from: URL(string: urlBase + url)!) else{
                    return .failure(.httpFailed)
                }
        do{
            let dataT = try decoder.decode(T.self, from: data)
            return .success(dataT)
        }
        catch{
            print(error)
            return .failure(.JsonDecodingFailed)
        }
    }
}

enum JSONError : Error, CustomStringConvertible{
    case fileNotFound(String)
    case JsonDecodingFailed
    case JsonEncodingFailed
    case initDataFailed
    case httpFailed
    case unknown
    var description : String {
        switch self {
        case .fileNotFound(let filename): return "File \(filename) not found"
        case .JsonDecodingFailed: return "JSON decoding failed"
        case .JsonEncodingFailed: return "JSON encoding failed"
        case .initDataFailed: return "Bad data format: initialization of data failed"
        case .unknown: return "unknown error"
        case .httpFailed: return "Error when asking server"
        }
    }
}
