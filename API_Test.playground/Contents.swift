import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

guard let url = URL(string: "https://yj8ke8qonl.execute-api.eu-west-1.amazonaws.com/characters") else {
    print("Invalid URL")
    PlaygroundPage.current.finishExecution()
    fatalError()
}

var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue("Bearer 754t!si@glcE2qmOFEcN", forHTTPHeaderField: "Authorization")

print("Starting request...")

URLSession.shared.dataTask(with: request) { data, response, error in
    defer { PlaygroundPage.current.finishExecution() }

    if let error = error {
        print("Error:", error.localizedDescription)
        return
    }

    guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid response")
        return
    }

    print("Status Code:", httpResponse.statusCode)

    guard let data = data else {
        print("No data received")
        return
    }

    print("Response:")
    print(String(decoding: data, as: UTF8.self))
}.resume()
