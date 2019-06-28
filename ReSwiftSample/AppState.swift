//
//  AppState.swift
//  ReSwiftSample
//
//  Created by Hank.Lee on 28/06/2019.
//  Copyright © 2019 hyeongkyu. All rights reserved.
//

import Foundation
import ReSwift

protocol Reducible {
    associatedtype State: StateType
    static var reducer: (Action, State?) -> State { get set }
}

protocol Storable {
    associatedtype State: StateType
    static var store: Store<State> { get set }
}

extension StateType where Self: Storable {
    typealias State = Self
}

struct AppState: StateType, Storable, Reducible {
    var count: Int = 0
    
    static var store: Store<State> = Store<State>(
        reducer: State.reducer,
        state: nil,
        middleware: [State.firstMiddleware]
    )
    
    static var reducer: (Action, State?) -> State = { action, state in
        var state = state ?? State()
        
        switch action {
        case is CounterActionIncrease :
            state.count += 1
        case is CounterActionDecrease:
            state.count -= 1
        case let counterActionSet as CounterActionSet:
            state.count = counterActionSet.newCount
        default:
            break
        }
        
        return state
    }
    
    static var firstMiddleware: Middleware<State> = { dispatch, getState in
        return { next in
            return { action in
                return next(action)
            }
        }
    }
    
    struct CounterActionIncrease: Action {}
    
    struct CounterActionDecrease: Action {}
    
    struct CounterActionSet: Action {
        var newCount: Int
    }
}
