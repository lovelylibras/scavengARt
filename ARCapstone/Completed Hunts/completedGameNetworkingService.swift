import Foundation

class CompletedGameNetworkingService {
    
    // Sets base URL for requests
    let baseUrl = "http://scavengart.herokuapp.com/"
    
    func request(endpoint: String,
                 completion: @escaping (Result<NewGame, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        // Sets variables
        var request = URLRequest(url: url)
    
        
    
     
        
      
        request.httpMethod = "POST"
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
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
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        
                        if let game = try? JSONDecoder().decode(NewGame.self, from: unwrappedData) {
                            print("game", game)
                            completion(.success(game))
                            
                        }else {
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




