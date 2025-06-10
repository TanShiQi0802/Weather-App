//
//  SampleSwiftUIView.swift
//  Weather App
//
//  Created by ptsq2579 on 4/6/25.
//

import SwiftUI

struct CityView: View {
    @StateObject var viewModel: CityViewModel
    @Environment(\.dismiss) private var dismiss
    let query: String

    init(query: String) {
        _viewModel = StateObject(wrappedValue: CityViewModel())
        self.query = query
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.7, green: 0.85, blue: 1.0), .blue]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            bodyContent
        }
        .task {
            await loadWeather()
        }
    }

    @ViewBuilder
    private var bodyContent: some View {
        if viewModel.isLoading {
            ProgressView("Loading weather...").font(.title)
        } else if !viewModel.weatherAvailable {
            errorContent
        } else {
            weatherContent
        }
    }

    private var errorContent: some View {
        VStack {
            HStack {
                Spacer()
                closeButton
            }
            Spacer()
            Text("City weather not found!")
                .font(.title)
                .foregroundStyle(.white)
                .padding()
                .multilineTextAlignment(.center)
                .fontWeight(.bold)

            Text("Please try again with a different city name.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Retry") {
                Task {
                    await loadWeather()
                }
            }
            .padding()
            .foregroundStyle(.white)
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Spacer()
        }
        .padding()
    }

    private var weatherContent: some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                closeButton
            }
            Spacer()

            if let image = viewModel.weatherImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: Layout.imageSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            }

            Text(query)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            Text(viewModel.weatherDesc.capitalized)
                .font(.title)
                .foregroundColor(.white)

            HStack {
                Image("temperature")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 5)
                Text("\(viewModel.temp)°C")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }

            HStack {
                Image("humidity")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 5)
                Text("Humidity:")
                    .fontWeight(.bold)
                Text("\(viewModel.humidity)%")
            }
            .foregroundStyle(.white)

            Spacer()
        }
        .padding()
    }

    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding()
    }

    private func loadWeather() async {
        viewModel.isLoading = true
        do {
            try await viewModel.fetchWeather(query: query)
        } catch {
        }
    }

    private enum Layout {
        static let iconSize: CGFloat = 35
        static let imageSize: CGFloat = 200
    }
}

#Preview {
    CityView(query: "A")
}
