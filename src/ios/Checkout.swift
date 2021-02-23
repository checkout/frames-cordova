//
// Checkout.swift
//
//
import Foundation
import Frames

class Checkout : CDVPlugin{
    
    var checkoutAPIClient: CheckoutAPIClient? = nil;

    @objc(initLiveClient:)
    func initLiveClient(command : CDVInvokedUrlCommand)
    {
        let result: CDVPluginResult;
        if let pubKey = command.argument(at: 0) as! String? {
            checkoutAPIClient = CheckoutAPIClient(publicKey: pubKey, environment: .live);
            result = CDVPluginResult(status: CDVCommandStatus_OK)
        } else {
            result = CDVPluginResult(status: CDVCommandStatus_ERROR)
        }
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }

    @objc(initSandboxClient:)
    func initSandboxClient(command : CDVInvokedUrlCommand)
    {
        let result: CDVPluginResult;
        if let pubKey = command.argument(at: 0) as! String? {
            checkoutAPIClient = CheckoutAPIClient(publicKey: pubKey, environment: .sandbox);
            result = CDVPluginResult(status: CDVCommandStatus_OK)
        } else {
            result = CDVPluginResult(status: CDVCommandStatus_ERROR)
        }
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }

    @objc(generateToken:)
    func generateToken(command : CDVInvokedUrlCommand)
    {
        var cdvResult: CDVPluginResult? = nil;
        let cardTokenRequest: CkoCardTokenRequest;
        do {
            cardTokenRequest = try DictionaryDecoder().decode(CkoCardTokenRequest.self, from: command.argument(at: 0))
        } catch {
            cdvResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to parse input")
            self.commandDelegate.send(cdvResult, callbackId: command.callbackId)
            return
        }
        if let ckoClient = checkoutAPIClient {
            ckoClient.createCardToken(card: cardTokenRequest) { result in
                switch result {
                case .success(let tokenResponse):
                    cdvResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: try? DictionaryEncoder().encode(tokenResponse) as! [String : Any])
                    break
                    
                case .failure(let err):
                    cdvResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err.localizedDescription)
                    break
                }
                self.commandDelegate.send(cdvResult, callbackId: command.callbackId)
            }
        } else {
            cdvResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Plugin not initialized")
            self.commandDelegate.send(cdvResult, callbackId: command.callbackId)
        }
    }
}

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()
    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()
    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
