//
//  MessageFilterExtension.swift
//  __NAME__
//
//  Created on __DATE__.
//

import IdentityLookup

/// Called by Messages for texts from unknown senders once the user turns the filter on in
/// Settings > Apps > Messages > Unknown & Spam. Messages deferred to the network are POSTed to
/// ILMessageFilterExtensionNetworkURL in Info.plist; that also needs the app to carry the
/// associated domain "messagefilter:<host>".
final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {

    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        let response = ILMessageFilterCapabilitiesQueryResponse()
        // Sub-folders shown under Transactions / Promotions, from ILMessageFilterSubAction:
        // response.transactionalSubActions = [.transactionalOrders, .transactionalReminders]
        // response.promotionalSubActions = [.promotionalOffers]
        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First try to decide with offline data.
        let (offlineAction, offlineSubAction) = offlineAction(for: queryRequest)

        switch offlineAction {
        case .allow, .junk, .promotion, .transaction:
            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            response.subAction = offlineSubAction
            completion(response)

        case .none:
            // Not sure offline: let the system ask the server in ILMessageFilterExtensionNetworkURL.
            context.deferQueryRequestToNetwork { networkResponse, error in
                let response = ILMessageFilterQueryResponse()
                response.action = .none
                response.subAction = .none
                if let networkResponse {
                    (response.action, response.subAction) = self.networkAction(for: networkResponse)
                } else {
                    NSLog("Error deferring query request to network: \(String(describing: error))")
                }
                completion(response)
            }

        @unknown default:
            completion(ILMessageFilterQueryResponse())
        }
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // Replace with your own rules, e.g. on queryRequest.sender and queryRequest.messageBody.
        if let body = queryRequest.messageBody, body.localizedCaseInsensitiveContains("you have won") {
            return (.junk, .none)
        }
        return (.none, .none)
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // Replace with parsing of networkResponse.urlResponse and networkResponse.data.
        (.none, .none)
    }
}
