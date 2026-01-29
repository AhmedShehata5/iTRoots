//
//  APIService.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//


import Alamofire
import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchHomeData(completion: @escaping (Result<[HomeItem], Error>) -> Void) {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let items = try JSONDecoder().decode([HomeItem].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchProducts(completion: @escaping (Result<[Product], AFError>) -> Void) {
        let url = Endpoints.products
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Product].self) { response in
                completion(response.result)
            }
        }
    }
