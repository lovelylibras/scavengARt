import Foundation

class NewUserNetworkingService {
    
    let baseUrl = "http://localhost:3030/api"
    
    func request(endpoint: String,
                 parameters: [String: Any],
                 completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        let queryItemData = components.query?.data(using: .utf8)
        
        request.httpBody = queryItemData
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NewUserNetworkingError.badResponse))
                    return
                }
                print(unwrappedResponse.statusCode)
                
                switch unwrappedResponse.statusCode {
                case 200 ..< 300:
                    print("success")
                default:
                    print("failure")
                }
                if let unwrappedError = error {
                    print("I'm in unwrappedError")
                    completion(.failure(unwrappedError))
                    
                    return
                }
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        
                        if let user = try? JSONDecoder().decode(User.self, from: unwrappedData) {
                            print("user", user)
                            completion(.success(user))
                            
                        }else {
                            print("I'm in unwrappedData")
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                            
                        }
                    } catch let error as NSError{
                        completion(.failure(error))
                    }
                }
            }
            
        }
        task.resume()
    }
    
    
}

enum NewUserNetworkingError: Error {
    case badUrl
    case badResponse
}
