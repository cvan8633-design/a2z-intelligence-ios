import SwiftUI

struct IntelligenceView: View {
    @StateObject private var viewModel = IntelligenceViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("A2Z Intelligence")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(Color.brandNavy)

            Text("Secure AI-Driven Investigation Pipeline")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Describe your investigation goal...", text: $viewModel.query)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .onSubmit {
                    Task { await viewModel.runInvestigation() }
                }

            Button {
                Task { await viewModel.runInvestigation() }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    }

                    Text(viewModel.isLoading ? "Running..." : "Run Investigation")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            .padding()
            .background(Color.brandNavy)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            ScrollView {
                TextEditor(text: .constant(viewModel.response))
                    .frame(minHeight: 180, maxHeight: 300)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(true)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

extension Color {
    static let brandNavy = Color(red: 4/255, green: 25/255, blue: 78/255)
}

@MainActor
final class IntelligenceViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var response: String = "Enter a prompt to start the A2Z investigation..."
    @Published var isLoading: Bool = false

    func runInvestigation() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        response = "Running investigation..."

        do {
            let result = try await APIService.investigate(prompt: trimmed)
            response = result
        } catch {
            response = "An error occurred while processing the investigation. Please try again."
        }

        isLoading = false
    }
}

enum APIService {
    static func investigate(prompt: String) async throws -> String {
        let payload = ["prompt": prompt]

        var request = URLRequest(url: URL(string: "https://your-api-url/investigate")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(InvestigationResponse.self, from: data)
        return decoded.message
    }
}

struct InvestigationResponse: Codable {
    let message: String
}