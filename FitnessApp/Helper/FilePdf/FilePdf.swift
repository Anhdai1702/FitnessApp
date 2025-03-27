//
//  FilePdf.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 18/3/25.
//

import UIKit

class PDFManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    static let shared = PDFManager()
    private var documentInteractionController: UIDocumentInteractionController?
    
    func openPDF(at fileName: String, from viewController: UIViewController) {
        guard let filePath = getFilePath(for: fileName) else {
            return
        }
        let fileURL = URL(fileURLWithPath: filePath)
        documentInteractionController = UIDocumentInteractionController(url: fileURL)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    private func getFilePath(for fileName: String) -> String? {
        return Bundle.main.path(forResource: fileName, ofType: "pdf")
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.rootViewController ?? UIViewController()
    }
}
