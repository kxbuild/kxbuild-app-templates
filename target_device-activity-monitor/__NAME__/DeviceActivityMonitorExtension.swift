//
//  DeviceActivityMonitorExtension.swift
//  __NAME__
//
//  Created on __DATE__.
//

import DeviceActivity

/// Woken by the system for schedules the app starts with DeviceActivityCenter().startMonitoring(...),
/// after the app got Family Controls authorization (AuthorizationCenter.shared.requestAuthorization).
/// Optionally override any of the functions below; the class name must match
/// NSExtensionPrincipalClass in Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // Handle the start of the interval, e.g. apply shields with ManagedSettingsStore.
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // Handle the event reaching its threshold.
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        // Handle the warning before the interval starts.
    }

    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        // Handle the warning before the interval ends.
    }

    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        // Handle the warning before the event reaches its threshold.
    }
}
