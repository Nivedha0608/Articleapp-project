//
//  API Service.swift
//  MyArticlesapp
//
//  Created by Nivedha Moorthy on 08/03/25.
//

import Foundation

class APIService {
    
    
    func fetchNews(page: Int, pageSize: Int, completion: @escaping (Result<[ArticleDetails], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2025-02-10&sortBy=publishedAt&apiKey=06d60f234e464a078a83da60e5487cbb&page=\(page)&pageSize=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiResponse = try decoder.decode(ArticleModel.self, from: data)
                completion(.success(apiResponse.articles ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchLikes(for articleID: String, completion: @escaping (Int?) -> Void) {
        let urlString = "https://cn-news-info-api.herokuapp.com/likes/\(articleID)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let likes = Int(String(decoding: data, as: UTF8.self)) {
                DispatchQueue.main.async {
                    completion(likes)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchComments(for articleID: String, completion: @escaping (Int?) -> Void) {
        let urlString = "https://cn-news-info-api.herokuapp.com/comments/\(articleID)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let comments = Int(String(decoding: data, as: UTF8.self)) {
                DispatchQueue.main.async {
                    completion(comments)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
}
