//
//  Gallery.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 06.11.22.
//

import SwiftUI
import PhotosUI

struct Gallery: UIViewControllerRepresentable {
    
    let action: (([Data]) -> Void)
    let existingImageCount: Int
    var limit = 5
    
    func makeCoordinator() -> Coordinator {
        return Gallery.Coordinator( parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = limit - existingImageCount
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: Gallery
        var images = [(Int, Data)]()
        
        init( parent: Gallery) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                
                for (index, media) in results.enumerated() {
                    
                    let itemProvider = media.itemProvider
                    self.getPhoto(from: itemProvider, resultCount: results.count, id: index)


                    DispatchQueue.main.async {
                        picker.dismiss(animated: true)
                    }
                }
                
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider, resultCount: Int, id: Int) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (img, error) in
                    if let uiimage = img as? UIImage {
                        if let imageData = uiimage.jpegData(compressionQuality: 0.8) {
                            DispatchQueue.main.async {
                                self.images.append((id, imageData))
                                if self.images.count == resultCount {
                                    self.images.sort(by: {$0.0 < $1.0 })
                                    self.parent.action(self.images.map{ $0.1 })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
