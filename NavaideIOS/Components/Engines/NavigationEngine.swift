//
//  NavigationEngine.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 8/2/25.
//

import Foundation
import SwiftUI

/// Controls transitions from one view to another. It keeps track of view history. It remembers last view for pops and current home view for popToRoot.
///
final class NavigationEngine {
    // There is ONLY one navigation engine in the app hence it is static
    static let shared = NavigationEngine()
    
    var viewHistory: [NavigationToken] = []
    
    func processNavigationToken(_ token: NavigationToken) -> any View {
        // Update the navigation record
        var nextToken = storeTokenInHistory(token)
        nextToken.transitionMode = transformTransitionMode(nextToken)
        
        // Now, do something with this token
        return nextToken.newView
    }
}

//
private extension NavigationEngine {
    func transformTransitionMode(_ token: NavigationToken) -> TransitionMode {
        let effectiveMode: TransitionMode
        // If we're popping or pop to root, we reverse the transition mode
        switch token.mode {
        case .pop, .popToRoot:
            effectiveMode = token.transitionMode.reverseMode
        default:
            effectiveMode = token.transitionMode
        }
        return effectiveMode
    }
}

// Update Token History
private extension NavigationEngine {
    func storeTokenInHistory(_ token: NavigationToken) -> NavigationToken {
        let nextToken: NavigationToken
        switch token.mode {
        case .modal:
            nextToken = addTokenToHistory(token)
        case .push:
            nextToken = addTokenToHistory(token)
        case .pop:
            nextToken = popTokenFromHistory() ?? token
        case .popToRoot:
            nextToken = viewHistory.first ?? token
        case .switchTo:
            nextToken = addTokenToHistory(token)
        }
        return nextToken
    }
    
    func clearHistory() {
        viewHistory.removeAll()
    }
    
    func addTokenToHistory(_ token: NavigationToken) -> NavigationToken {
        viewHistory.append(token)
        return token
    }
    
    func popTokenFromHistory() -> NavigationToken? {
        if viewHistory.isEmpty {
            return nil
        }
        return viewHistory.removeLast()
    }
}
