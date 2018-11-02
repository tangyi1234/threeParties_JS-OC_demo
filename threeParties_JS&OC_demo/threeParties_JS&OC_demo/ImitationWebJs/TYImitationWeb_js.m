//
//  TYImitationWeb_js.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/11/2.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "TYImitationWeb_js.h"

NSString *TYImitationWebMeson_js(){
    #define __wvjb_js_func__(x) #x
    static NSString *InteractionJsCode = @__wvjb_js_func__(
    ;(function(){
        if (window.TYImitationWebMeson) {
            return;
        }
        
        if (!window.onerror) {
            window.onerror = function(msg, url, line) {
                console.log("WebViewJavascriptBridge: ERROR:" + msg + "@" + url + ":" + line);
            }
        }
        window.TYImitationWebMeson = {
//        registerHandler: registerHandler,
//        callHandler: callHandler,
//        disableJavscriptAlertBoxSafetyTimeout: disableJavscriptAlertBoxSafetyTimeout,
//        _fetchQueue: _fetchQueue,
//        _handleMessageFromObjC: _handleMessageFromObjC
        };
        
        var messageHandlers = {};
        
        //传入block,这是html的js调用的.
        function registerHandler(handlerName, handler) {
            messageHandlers[handlerName] = handler;
        }
        
        function _dispatchMessageFromObjC(messageJSON) {
            if (dispatchMessagesWithTimeoutSafety) {
                setTimeout(_doDispatchMessageFromObjC);
            } else {
                _doDispatchMessageFromObjC();
            }
            
            function _doDispatchMessageFromObjC() {
                var message = JSON.parse(messageJSON);
                
                var handler = messageHandlers[message.handlerName];
                if (!handler) {
                    console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message);
                } else {
                    handler(message.data, responseCallback);
                }
            }
        }
        
    })();
    );
    return InteractionJsCode;
};
