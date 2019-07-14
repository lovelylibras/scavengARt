import Foundation

class GamesNetworkingService {
    
    // Sets base URL for requests
    let baseUrl = "http://scavengart.herokuapp.com/"
    
    func request(endpoint: String,
                 completion: @escaping (Result<[Game], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        // Sets variables
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
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
                    completion(.failure(unwrappedError))
                    
                    return
                }
                if let unwrappedData = data {
                    do {
                 
                     
                        
                        if let gamesResponse = try? JSONDecoder().decode([Game].self, from: unwrappedData) {
                        
                            completion(.success(gamesResponse))
                            
                        }else {
                            print("ELSE FAIL")
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                            
                        }
                    } catch let error as NSError{
                        print("FAIL")
                        completion(.failure(error))
                    }
                }
            }
            
        }
        task.resume()
    }
}

// GIVE TYPES FOR ERRORS
enum GamesNetworkingError: Error {
    case badUrl
    case badResponse
}
