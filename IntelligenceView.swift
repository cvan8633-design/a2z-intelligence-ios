import SwiftUI

struct IntelligenceView: View {
    @State private var query: String = ""
    @State private var response: String = "Enter a prompt to start the A2Z investigation..."
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("A2Z Intelligence")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 4/255, green: 25/255, blue: 78/255))
                .padding(.top, 40)

            Text("Secure AI-Driven Investigation Pipeline")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Describe your investigation goal...", text: $query)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

            Button(action: runInvestigation) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                } else {
                    Text("Run Investigation")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 4/255, green: 25/255, blue: 78/255))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            ScrollView {
                Text(response)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding()
            }
            Spacer()
        }
        .background(Color(red: 245/255, green: 245/255, blue: 245/255))
        .edgesIgnoringSafeArea(.all)
    }

    func runInvestigation() {
        isLoading = true
        // Logic to call Python API: POST /investigate
        // After response:
        isLoading = false
    }
}
