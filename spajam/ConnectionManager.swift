import Foundation
import PeerKit
import MultipeerConnectivity

enum Event: String {
    case Message = "Message"
}

struct ConnectionManager {
    
    static var peers: [MCPeerID] {
        return PeerKit.session?.connectedPeers as [MCPeerID]? ?? []
    }
    
    static func start() {
        PeerKit.transceive(serviceType: "peerkit-sample")
    }
    
    static func onConnect(_ run: PeerBlock?) {
        PeerKit.onConnect = run
    }

    static func onDisconnect(_ run: PeerBlock?) {
        PeerKit.onDisconnect = run
    }
    
    static func sendMessageEvent(message: String, from: String = PeerKit.myName, toPeers peers: [MCPeerID]? = PeerKit.session?.connectedPeers as [MCPeerID]?) {
        let anyObject = ["message": message, "from": from]
        PeerKit.sendEvent(Event.Message.rawValue, object: anyObject as AnyObject, toPeers: peers)
    }
    
    static func onEvent(_ event: Event, run: ObjectBlock?) {
        if let run = run {
            PeerKit.eventBlocks[event.rawValue] = run
        } else {
            PeerKit.eventBlocks.removeValue(forKey:event.rawValue)
        }
    }
    
}
