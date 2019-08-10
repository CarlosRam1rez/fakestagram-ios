//
//  CreatePostClient.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 4/27/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation


struct CreatePostBase64: Codable {
    let title: String
    let imageData: String
}

class CreatePostClient {
    let client = Client()
    let path = "/api/posts"
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    let decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func create(payload: CreatePostBase64, success: @escaping (Post) -> Void){
        guard let data = try? encoder.encode(payload) else {return}
        client.request("POST",path: path, body: data, completionHandler:{(response, data) in
            if response.successful(){
                guard let data = data else {
                    print("Empty data response")
                    return
                }
                do{
                let json = try self.decoder.decode(Post.self, from: data)
                    success(json)
                }catch let err {print("Error on serialization: \(err.localizedDescription)")}}
            else{
                print("Error on response: \(response.status) - \(response.rawResponse): \nBody:\t\(String(describing: data))")}
        }, errorHandler: onError(error:))
        }
    
    func onError(error: Error?) -> Void {
        guard let err = error else {return}
        print("error on request: \(err.localizedDescription)")
    }
}
