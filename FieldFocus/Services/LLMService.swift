import Foundation
import os.log

private let logger = Logger(subsystem: "com.appsOnapps.FieldFocus", category: "LLMService")

/// Streams chat completions from the local llama-server running on the 4080 PC.
/// Endpoint: http://192.168.1.9:8080/v1/chat/completions (OpenAI-compatible)
struct LLMService {

    static let baseURL = "http://192.168.1.9:8080"

    struct Message: Encodable {
        let role: String
        let content: String
    }

    enum LLMError: Error, LocalizedError {
        case badStatus(Int)
        case serverUnreachable

        var errorDescription: String? {
            switch self {
            case .badStatus(let code): return "Server returned HTTP \(code)"
            case .serverUnreachable:   return "Could not reach the local Llama server"
            }
        }
    }

    /// Streams a chat completion, calling `onToken` on the main actor for each received token.
    static func streamChat(
        messages: [Message],
        onToken: @MainActor @escaping (String) -> Void
    ) async throws {
        guard let url = URL(string: "\(baseURL)/v1/chat/completions") else { return }

        var req = URLRequest(url: url, timeoutInterval: 120)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer local", forHTTPHeaderField: "Authorization")

        let body = ChatRequest(
            model: "llama3.1-8b-instruct",
            messages: messages,
            stream: true,
            temperature: 0.7,
            max_tokens: 1024
        )
        req.httpBody = try JSONEncoder().encode(body)

        logger.info("Sending \(messages.count) messages to Llama server")

        let (asyncBytes, response) = try await URLSession.shared.bytes(for: req)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw LLMError.badStatus(http.statusCode)
        }

        for try await line in asyncBytes.lines {
            guard line.hasPrefix("data: ") else { continue }
            let payload = String(line.dropFirst(6))
            guard payload != "[DONE]" else { break }
            guard
                let data = payload.data(using: .utf8),
                let chunk = try? JSONDecoder().decode(StreamChunk.self, from: data),
                let content = chunk.choices.first?.delta.content,
                !content.isEmpty
            else { continue }

            await onToken(content)
        }
    }
}

// MARK: - Codable helpers

private struct ChatRequest: Encodable {
    let model: String
    let messages: [LLMService.Message]
    let stream: Bool
    let temperature: Double
    let max_tokens: Int
}

private struct StreamChunk: Decodable {
    let choices: [Choice]
    struct Choice: Decodable {
        let delta: Delta
    }
    struct Delta: Decodable {
        let content: String?
    }
}
