import Foundation

public struct MatchedRoute {
    public let url: URL
    public let parametars: [String: String]
    public let patternIdentifier: PatternIdentifier

    public init(url: URL, parameters: [String: String], patternIdentifier: PatternIdentifier) {
        self.url = url
        self.parametars = parameters
        self.patternIdentifier = patternIdentifier
    }
}

public class RouterXCore {
    private let rootRoute: RouteVertex

    public init() {
        self.rootRoute = RouteVertex()
    }

    public func registerRoutingPattern(pattern: String, patternIdentifier: PatternIdentifier) -> Bool {
        let tokens = RoutingPatternScanner.tokenize(expression: pattern)

        do {
            try RoutingPatternParser.parseAndAppendTo(rootRoute: self.rootRoute, routingPatternTokens: tokens, patternIdentifier: patternIdentifier)

            return true
        } catch {
            return false
        }
    }

    public func matchURL(url: URL) -> MatchedRoute? {
        guard let path = url.path else {
            return nil
        }

        let tokens = URLPathScanner.tokenize(path: path)
        if tokens.isEmpty {
            return nil
        }

        var parameters: [String: String] = [:]

        var tokensGenerator = tokens.makeIterator()
        var targetRoute: RouteVertex = rootRoute
        while let token = tokensGenerator.next() {
            if let determinativeRoute = targetRoute.nextRoutes[token.routeEdge] {
                targetRoute = determinativeRoute
            } else if let epsilonRoute = targetRoute.epsilonRoute {
                targetRoute = epsilonRoute.1
                parameters[epsilonRoute.0] = String(token).removingPercentEncoding
            } else {
                return nil
            }
        }

        return MatchedRoute(url: url, parameters: parameters, patternIdentifier: targetRoute.patternIdentifier!)
    }

    public func matchURLPath(urlPath: String) -> MatchedRoute? {
        guard let url = URL(string: urlPath) else {
            return nil
        }

        return matchURL(url: url)
    }
}
