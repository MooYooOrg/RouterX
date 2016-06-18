import Foundation

public typealias MatchRouteHandler = ((URL, parameters: [String:String], context: AnyObject?) -> Void)
public typealias UnmatchRouteHandler = ((URL, context: AnyObject?) -> ())

public class Router {
    private let core: RouterXCore = RouterXCore()
    private let defaultUnmatchHandler: UnmatchRouteHandler

    private var handlerMappings: [PatternIdentifier: MatchRouteHandler] = [:]

    public init(defaultUnmatchHandler: UnmatchRouteHandler? = nil) {
        if let unmatchHandler = defaultUnmatchHandler {
            self.defaultUnmatchHandler = unmatchHandler
        } else {
            self.defaultUnmatchHandler = { (_, _) in }
        }
    }

    public func registerRoutingPattern(pattern: String, handler: MatchRouteHandler) -> Bool {
        let patternIdentifier = pattern.hashValue
        if self.core.registerRoutingPattern(pattern: pattern, patternIdentifier: patternIdentifier) {
            self.handlerMappings[patternIdentifier] = handler

            return true
        } else {
            return false
        }
    }

    public func matchURLAndDoHandler(url: URL, context: AnyObject? = nil, unmatchHandler: UnmatchRouteHandler? = nil) -> Bool {
        guard let matchedRoute = self.core.matchURL(url: url) else {
            if let handler = unmatchHandler {
                handler(url, context: context)
            } else {
                self.defaultUnmatchHandler(url, context: context)
            }

            return false
        }

        self.handlerMappings[matchedRoute.patternIdentifier]!(url, parameters: matchedRoute.parametars, context: context)

        return true
    }

    public func matchURLPathAndDoHandler(urlPath: String, context: AnyObject? = nil, unmatchHandler: UnmatchRouteHandler? = nil) -> Bool {
        guard let url = URL(string: urlPath) else {
            return false
        }

        return matchURLAndDoHandler(url: url, context: context, unmatchHandler: unmatchHandler)
    }
}
