//
//  BackgroundDownloadHandler.swift
//  __NAME__
//
//  Created on __DATE__.
//

import BackgroundAssets
import ExtensionFoundation
import StoreKit

/// Downloader for asset packs hosted by Apple (uploaded in App Store Connect). The system schedules
/// the downloads itself; the app reads them with AssetPackManager. Needs, in the app's Info.plist:
/// BAAppGroupID = the App Group shared with this extension, BAHasManagedAssetPacks = YES and
/// BAUsesAppleHosting = YES.
@main
struct DownloaderExtension: StoreDownloaderExtension {

    func shouldDownload(_ assetPack: AssetPack) -> Bool {
        // Use this method to filter out asset packs that the system would otherwise download automatically.
        // You can also remove this method entirely if you just want to rely on the default download behavior.
        true
    }
}
