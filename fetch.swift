import Foundation

func fetchWikipediaData(for searchTerm: String) {
    let urlString = "https://en.wikipedia.org/w/api.php?action=opensearch&search=\(searchTerm)&limit=10&namespace=0&format=json&origin=*"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        defer { semaphore.signal() }  
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data returned")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                print(json)
            } else {
                print("Invalid JSON format")
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    task.resume()
    semaphore.wait()  
}

fetchWikipediaData(for: "Star wars")
