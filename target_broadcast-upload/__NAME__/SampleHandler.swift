//
//  SampleHandler.swift
//  __NAME__
//
//  Created on __DATE__.
//

import ReplayKit

/// Runs while a ReplayKit broadcast is live and receives the captured sample buffers.
/// Start it from the app with RPSystemBroadcastPickerView (preferredExtension = "__BUNDLE_ID__")
/// or from the Control Center screen-recording button (long press).
class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but is optional.
    }

    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }

    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }

    override func broadcastFinished() {
        // User has requested to finish the broadcast.
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            // Handle video sample buffer
            break
        case .audioApp:
            // Handle audio sample buffer for app audio
            break
        case .audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            break
        }
    }
}
