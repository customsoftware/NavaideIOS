//
//  NavigationEnumerations.swift
//  NavaideIOS
//
//  Created by Kenneth Cluff on 8/2/25.
//

//  A lexicon:
///  "flow" this is short for work flow. When you do something on the app, there is typically a given sequence of views wherein a user does
///  something then when finished with that step, they go on to another step. When they finish, they return to the starting point. A starting point
///  can be the home view or the flow from which they left to do this new flow.

import SwiftUI

/// This determines the type of transition from one view to the other
enum NavigationMode {
    /// This is where there is a "back" button to go back one view
    case push
    /// This is where the rest of the app pauses while the user interacts with this view. When dismissed, the user returns to the calling view automatically
    case modal
    /// This is when the user wants to go back to the previous view
    case pop
    /// This is when the user wants to return to the beginning of the work flow they are in
    case popToRoot
    /// This is where the flow switches to the start of a different flow, which can push. When the other flow ends, the user returns to this flow.
    case switchTo
}

/// This determines which direction the new view appears on the screen
enum TransitionMode {
    /// Moves from leading edge of view to trailing edge of view
    case swipeLeading
    /// Moves from trailing edge of view to leading edge of view
    case swipeTrailing
    /// Moves from the bottom up
    case swipeUp
    /// Moves from the top down
    case swipeDown
    /// This fades out the old and fades in the new. This is used with the "switchTo" navigation mode
    case fade
    
    var reverseMode: TransitionMode {
        let returnMode: TransitionMode
        switch self {
        case .swipeLeading:
            returnMode = .swipeTrailing
        case .swipeTrailing:
            returnMode = .swipeLeading
        case .swipeUp:
            returnMode = .swipeDown
        case .swipeDown:
            returnMode = .swipeUp
        case .fade:
            returnMode = .fade
        }
        return returnMode
    }
}

struct NavigationToken {
    var mode: NavigationMode
    var transitionMode: TransitionMode
    let currentView: AnyView?
    let newView: AnyView
    let animated: Bool = true
}
