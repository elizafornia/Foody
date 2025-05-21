//
//  ShakeDetector.swift
//  Makanan
//
//  Created by Eliza Vornia on 11/05/25.
//
import SwiftUI
import UIKit

struct ShakeDetector: UIViewControllerRepresentable {
    var onShake: () -> Void

    class Coordinator: NSObject {
        var onShake: () -> Void

        init(onShake: @escaping () -> Void) {
            self.onShake = onShake
        }
    }

    class ShakeViewController: UIViewController {
        var onShake: () -> Void

        init(onShake: @escaping () -> Void) {
            self.onShake = onShake
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var canBecomeFirstResponder: Bool {
            return true
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.becomeFirstResponder()
        }

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                // Memastikan haptic feedback berjalan pada main thread
                DispatchQueue.main.async {
                    let generator = UIImpactFeedbackGenerator(style: .heavy) // Menggunakan style .heavy untuk haptic lebih kuat
                    generator.prepare()
                    generator.impactOccurred()
                    print("Shake detected with heavy haptic feedback")
                    self.onShake() // Memanggil aksi shake
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return ShakeViewController(onShake: onShake)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onShake: onShake)
    }
}

#Preview {
    ShakeDetector(onShake: {
        print("Shake detected with strong feedback!")
    })
}
