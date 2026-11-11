//
//  PhotoEditingViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import Photos
import PhotosUI

/// Opened from Edit > ••• in the Photos app. Photos supplies the navigation bar (Cancel / Done);
/// this view only shows the image being edited. Built in code, no storyboard.
class PhotoEditingViewController: UIViewController, PHContentEditingController {

    var input: PHContentEditingInput?
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - PHContentEditingController

    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        false
    }

    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandle(_:), contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        input = contentEditingInput
        imageView.image = contentEditingInput.displaySizeImage ?? placeholderImage
    }

    func finishContentEditing(completionHandler: @escaping (PHContentEditingOutput?) -> Void) {
        guard let input else {
            completionHandler(nil)
            return
        }
        // Render and provide output on a background queue.
        DispatchQueue.global().async {
            let output = PHContentEditingOutput(contentEditingInput: input)

            // Provide new adjustments and render output to given location.
            // output.adjustmentData = PHAdjustmentData(formatIdentifier: "__BUNDLE_ID__", formatVersion: "1.0", data: Data())
            // let renderedJPEGData = ...
            // try? renderedJPEGData.write(to: output.renderedContentURL)

            // Call completion handler to commit edit to Photos.
            completionHandler(output)
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Whether to ask before discarding changes on Cancel (typically true when there are unsaved edits).
        false
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditing(completionHandler:) while you prepare output.
    }
}
