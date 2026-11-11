//
//  ShieldConfigurationExtension.swift
//  __NAME__
//
//  Created on __DATE__.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Supplies the look of the shield shown over apps and websites blocked through ManagedSettingsStore.
/// The system uses its default appearance for any method that is not overridden; the class name
/// must match NSExtensionPrincipalClass in Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(
            title: ShieldConfiguration.Label(text: "Time's up", color: .label),
            subtitle: ShieldConfiguration.Label(text: "\(application.localizedDisplayName ?? "This app") is blocked right now.", color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white)
        )
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
