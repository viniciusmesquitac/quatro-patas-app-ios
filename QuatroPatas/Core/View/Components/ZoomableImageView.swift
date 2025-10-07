//
//  ZoomableImageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//

import SwiftUI
struct ZoomableImageView: UIViewRepresentable {
    let imageURL: URL

    @CacheProvider(type: .fileManager)
    var cacheProvider

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.delegate = context.coordinator

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        context.coordinator.imageView = imageView

        // 👉 Adiciona gesto de duplo toque
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }

    func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return url.absoluteString
        }
        return token
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        guard context.coordinator.imageView?.image == nil else { return }
        
        if let imageData = cacheProvider.get(key: getToken(url: imageURL)) as? Data,
           let cachedImage = UIImage(data: imageData) {
            DispatchQueue.main.async {
                context.coordinator.imageView?.image = cachedImage
                context.coordinator.imageView?.frame = scrollView.bounds
            }
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        context.coordinator.imageView?.image = image
                        context.coordinator.imageView?.frame = scrollView.bounds
                    }
                    // Salva no cache
                    try cacheProvider.save(data, for: getToken(url: imageURL))
                }
            } catch {
                print("❌ Erro ao carregar imagem: \(error.localizedDescription)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        weak var imageView: UIImageView?

        // ✅ Ao dar duplo toque, volta o zoom para 1.0
        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }
            
            if scrollView.zoomScale > 1.0 {
                // volta ao zoom inicial
                scrollView.setZoomScale(1.0, animated: true)
            } else {
                // dá um pequeno zoom no ponto tocado
                let pointInView = gesture.location(in: imageView)
                let newZoomScale = min(scrollView.maximumZoomScale, scrollView.zoomScale * 2)
                let scrollViewSize = scrollView.bounds.size

                let width = scrollViewSize.width / newZoomScale
                let height = scrollViewSize.height / newZoomScale
                let x = pointInView.x - (width / 2)
                let y = pointInView.y - (height / 2)

                let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
                scrollView.zoom(to: rectToZoom, animated: true)
            }
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let imageView = imageView else { return }
            let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0)
            imageView.center = CGPoint(
                x: scrollView.contentSize.width * 0.5 + offsetX,
                y: scrollView.contentSize.height * 0.5 + offsetY
            )
        }
    }
}



struct ZoomableCarouselView: View {
    let images: [String]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                if let url = URL(string: images[index]) {
                    ZoomableImageView(imageURL: url)
                        .tag(index)
                        .ignoresSafeArea()
                        .background(Color.black)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black.ignoresSafeArea())
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
