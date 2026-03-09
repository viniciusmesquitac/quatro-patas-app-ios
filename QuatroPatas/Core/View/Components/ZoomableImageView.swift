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
        scrollView.backgroundColor = .black

        // ImageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        context.coordinator.imageView = imageView

        // Constraints: prende o imageView no scrollView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
        ])

        // Loading indicator
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(indicator)
        context.coordinator.indicator = indicator

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])

        // Double tap
        let doubleTap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDoubleTap(_:))
        )
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }


    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        let key = imageURL.getImageToken()

        if context.coordinator.currentKey == key, context.coordinator.imageView?.image != nil {
            return
        }

        context.coordinator.currentKey = key
        context.coordinator.imageView?.image = nil
        context.coordinator.indicator?.startAnimating()

        // 1) tenta cache
        if let imageData = cacheProvider.get(key: key) as? Data,
           let cachedImage = UIImage(data: imageData) {
            DispatchQueue.main.async {
                context.coordinator.imageView?.image = cachedImage
                context.coordinator.indicator?.stopAnimating()
                scrollView.setZoomScale(1.0, animated: false)
            }
            return
        }

        // 2) baixa da rede (cancelando task anterior se trocar de página rápido)
        context.coordinator.loadTask?.cancel()
        context.coordinator.loadTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                try Task.checkCancellation()

                if let image = UIImage(data: data) {
                    await MainActor.run {
                        guard context.coordinator.currentKey == key else { return }
                        context.coordinator.imageView?.image = image
                        context.coordinator.indicator?.stopAnimating()
                        scrollView.setZoomScale(1.0, animated: false)
                    }
                    try cacheProvider.save(data, for: key)
                } else {
                    await MainActor.run {
                        context.coordinator.indicator?.stopAnimating()
                    }
                }
            } catch is CancellationError {
                // ignora
            } catch {
                await MainActor.run {
                    context.coordinator.indicator?.stopAnimating()
                }
                print("❌ Erro ao carregar imagem: \(error.localizedDescription)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        weak var imageView: UIImageView?
        weak var indicator: UIActivityIndicatorView?
        var loadTask: Task<Void, Never>?
        var currentKey: String?

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }

            if scrollView.zoomScale > 1.0 {
                scrollView.setZoomScale(1.0, animated: true)
            } else {
                let pointInView = gesture.location(in: imageView)
                let newZoomScale = min(scrollView.maximumZoomScale, scrollView.zoomScale * 2)
                let size = scrollView.bounds.size

                let width = size.width / newZoomScale
                let height = size.height / newZoomScale
                let x = pointInView.x - (width / 2)
                let y = pointInView.y - (height / 2)

                scrollView.zoom(to: CGRect(x: x, y: y, width: width, height: height), animated: true)
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

        deinit {
            loadTask?.cancel()
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
                SFIcon.image(.close)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
