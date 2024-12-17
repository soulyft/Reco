//
//  ProductResponse.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import Foundation

struct ProductResponse: Decodable {
    let name: String
    let price: Double
    let summary: String
    let imageURL: String
    let affiliateLink: String
}

struct FunctionCallArguments: Decodable {
    let query: String
    let userProfile: UserProfileArguments

    struct UserProfileArguments: Decodable {
        let budgetSensitivity: Double
        let brandLoyalty: Double
    }
}

enum APIClientError: Error, LocalizedError {
    case invalidResponse
    case decodingError
    case serverError(Int, String)
    case missingAPIKey
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingError:
            return "Failed to decode the server response."
        case .serverError(let code, let body):
            return "Server error \(code): \(body)"
        case .missingAPIKey:
            return "API key is missing. Please check your configuration."
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}

class APIClient {
    func fetchRecommendation(for query: String, userProfile: UserProfile) async throws -> ProductResponse {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": """
                You are a product recommendation assistant. 
                Respond **only** with JSON in this format:
                {"name": "Product Name", "price": 29.99, "summary": "Description", "imageURL": "https://image.com", "affiliateLink": "https://link.com"}
                use budget sensitivity to stay close to the range requested on a sliding scale from 0-1
                use brand loyalty to suggest well known brands on a sliding scale from 0-1
                """],
                ["role": "user", "content": "Query: \(query), Budget: \(userProfile.budgetSensitivity), Brand Loyalty: \(userProfile.brandLoyalty)"]
            ],
            "temperature": 0.7,
            "max_tokens": 150
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(loadAPIKey() ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        // Ensure the response is an HTTPURLResponse and check the status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            throw APIClientError.serverError(httpResponse.statusCode, responseBody)
        }

        // Log raw response for debugging
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Raw Response Body: \(responseBody)")
        }

        // Decode the OpenAI API response
        let apiResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)

        guard let messageContent = apiResponse.choices.first?.message.content else {
            throw APIClientError.invalidResponse
        }

        // Decode message content into ProductResponse
        let productResponse = try JSONDecoder().decode(ProductResponse.self, from: Data(messageContent.utf8))
        return productResponse
    }

    private func loadAPIKey() -> String? {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            return nil
        }
        return plist["OPENAI_API_KEY"] as? String
    }
}

// Define the structures to match the OpenAI API response
struct OpenAIChatResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let role: String
    let content: String?
}
