//
//  URLSessionExtension.swift
//  RecipeApp
//
//  Created by Nicolas Bofi on 04/03/2022.
//

import Foundation
import PhotosUI


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

    static func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "https://nicolas-ig.alwaysdata.net/api/file/upload")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.5)!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
}
