//
//  URLSessionExtension.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 04/03/2022.
//

import Foundation

extension URLSession{
    static var urlBase = "https://nicolas-ig.alwaysdata.net/api/"
    
    func create<T: Codable>(urlEnd: String, data: T) async -> Result<T, JSONError>{
        var urlRequest = URLRequest(url: URL(string: URLSession.urlBase + urlEnd)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encoded = await JSONHelper.encode(data: data) else {
            return .failure(.JsonEncodingFailed)
        }
            
        print(encoded)
        
        guard let (data, response) = try? await URLSession.shared.upload(for: urlRequest, from: encoded) else{
            return .failure(.httpFailed)
        }
        
        let httpresponse = response as! HTTPURLResponse // le bon type
        if httpresponse.statusCode == 201 ||  httpresponse.statusCode == 200 { // tout s'est bien passé
            guard let decoded:  T = JSONHelper.decode(data: data) else {
                return .failure(.JsonDecodingFailed)
            }
            
            return .success(decoded) // Updated
        } else{
            print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))") // print à éviter dans une app !
            return .failure(.httpFailed)
        }
    }
    
    func update<T:Codable>(urlEnd: String, data: T) async -> Result<Bool, JSONError>{
        var urlRequest = URLRequest(url: URL(string: URLSession.urlBase + urlEnd)!)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encoded = await JSONHelper.encode(data: data) else {
            return .failure(.JsonEncodingFailed)
        }
            
        print(encoded)
        
        guard let (_, response) = try? await URLSession.shared.upload(for: urlRequest, from: encoded) else{
            return .failure(.httpFailed)
        }
        
        let httpresponse = response as! HTTPURLResponse // le bon type
        if httpresponse.statusCode == 201 ||  httpresponse.statusCode == 200 { // tout s'est bien passé
            return .success(true) // Updated
        } else{
            print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))") // print à éviter dans une app !
            return .failure(.httpFailed)
        }
    }
}
