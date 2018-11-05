//
//  TYImitationWeb_js.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/11/2.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "TYImitationWeb_js.h"

//NSString *TYImitationWebMeson_js(){
//    #define __wvjb_js_func__(x) #x
//    static NSString *InteractionJsCode = @__wvjb_js_func__(
//    ;(function(){
//        if (window.TYImitationWebMeson) {
//            return;
//        }
//        
//        if (!window.onerror) {
//            window.onerror = function(msg, url, line) {
//                console.log("WebViewJavascriptBridge: ERROR:" + msg + "@" + url + ":" + line);
//            }
//        }
//        window.TYImitationWebMeson = {
//        registerHandler: registerHandler,
////        callHandler: callHandler,
//        disableJavscriptAlertBoxSafetyTimeout: disableJavscriptAlertBoxSafetyTimeout,
////        _fetchQueue: _fetchQueue,
//        _handleMessageFromObjC: _handleMessageFromObjC
//        };
//        var handlerNameStr;
//        var messagingIframe;
//        var messageHandlers = {};
//        var CUSTOM_PROTOCOL_SCHEME = 'https';
//        var QUEUE_HAS_MESSAGE = '__wvjb_queue_message__';
//        
//        messagingIframe = document.createElement('iframe');
//        messagingIframe.style.display = 'none';
//        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
//        document.documentElement.appendChild(messagingIframe);
//        
//        //传入block,这是html的js调用的.
//        function registerHandler(handlerName, handler) {
//            messageHandlers[handlerName] = handler;
//            handlerNameStr = handlerName;
//        }
//        
//        function disableJavscriptAlertBoxSafetyTimeout() {
//            dispatchMessagesWithTimeoutSafety = false;
//        }
//        
//        function _dispatchMessageFromObjC(messageJSON) {
//            console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:");
//            if (dispatchMessagesWithTimeoutSafety) {
//                setTimeout(_doDispatchMessageFromObjC);
//            } else {
//                _doDispatchMessageFromObjC();
//            }
//            
//            function _doDispatchMessageFromObjC() {
//                var message = JSON.parse(messageJSON);
//                
//                var handler = messageHandlers[message.handlerName];
//                if (!handler) {
//                    console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message);
//                } else {
//                    handler(message.data, responseCallback);
//                }
//            }
//        }
//        
//        messagingIframe = document.createElement('iframe');
//        messagingIframe.style.display = 'none';
//        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
//        document.documentElement.appendChild(messagingIframe);
//        
//        registerHandler("_disableJavascriptAlertBoxSafetyTimeout", disableJavscriptAlertBoxSafetyTimeout);
//        setTimeout(nameStr, 0);
//        function nameStr(){
//            var handler = messageHandlers[handlerNameStr];
//            if (!handler) {
//                console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message);
//            } else {
//                handler();
//            }
//        }
//        // 这是用来设定一个时间, 时间到了, 就会执行一个指定的 method。
//        setTimeout(_callWVJBCallbacks, 0);
//        function _callWVJBCallbacks() {
//            var callbacks = window.WVJBCallbacks;
//            delete window.WVJBCallbacks;
//            for (var i=0; i<callbacks.length; i++) {
//                callbacks[i](TYImitationWebMeson);
//            }
//        }
//        
//    })();
//    );
//    #undef __wvjb_js_func__
//    return InteractionJsCode;
//};

//问题出在这里
NSString * TYImitationWebMeson_js() {
#define __wvjb_js_func__(x) #x
    
    // BEGIN preprocessorJSCode
    static NSString * preprocessorJSCode = @__wvjb_js_func__(
                                                             ;(function() {
        if (window.TYImitationWebMeson) {
            return;
        }
        
        if (!window.onerror) {
            window.onerror = function(msg, url, line) {
                console.log("WebViewJavascriptBridge: ERROR:" + msg + "@" + url + ":" + line);
            }
        }
        window.TYImitationWebMeson = {
        registerHandler: registerHandler,
        callHandler: callHandler,
        disableJavscriptAlertBoxSafetyTimeout: disableJavscriptAlertBoxSafetyTimeout,
        _fetchQueue: _fetchQueue,
        _handleMessageFromObjC: _handleMessageFromObjC
        };
        
        var messagingIframe;
        //存储数据容器
        var sendMessageQueue = [];
        var messageHandlers = {};
        
        var CUSTOM_PROTOCOL_SCHEME = 'https';
        var QUEUE_HAS_MESSAGE = '__wvjb_queue_message__';
        
        var responseCallbacks = {};
        var uniqueId = 1;
        var dispatchMessagesWithTimeoutSafety = true;
        
        //传入block,这是html的js调用的.
        function registerHandler(handlerName, handler) {
            messageHandlers[handlerName] = handler;
        }
        //js调用oc
        function callHandler(handlerName, data, responseCallback) {
            console.log("来了这里没有1");
            if (arguments.length == 2 && typeof data == 'function') {
                responseCallback = data;
                data = null;
            }
            _doSend({ handlerName:handlerName, data:data }, responseCallback);
        }
        function disableJavscriptAlertBoxSafetyTimeout() {
            dispatchMessagesWithTimeoutSafety = false;
        }
        //数据解析
        function _doSend(message, responseCallback) {
            console.log("来了这里没有");
            if (responseCallback) {
                var callbackId = 'cb_'+(uniqueId++)+'_'+new Date().getTime();
                responseCallbacks[callbackId] = responseCallback;
                message['callbackId'] = callbackId;
            }
            sendMessageQueue.push(message);
            messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
        }
        
        //从这里获取js传入到oc中数据
        function _fetchQueue() {
            console.log("来了这里没有2");
            var messageQueueString = JSON.stringify(sendMessageQueue);
            sendMessageQueue = [];
            return messageQueueString;
        }
        
        function _dispatchMessageFromObjC(messageJSON) {
            if (dispatchMessagesWithTimeoutSafety) {
                setTimeout(_doDispatchMessageFromObjC);
            } else {
                _doDispatchMessageFromObjC();
            }
            
            function _doDispatchMessageFromObjC() {
                var message = JSON.parse(messageJSON);
                var messageHandler;
                var responseCallback;
                
                if (message.responseId) {
                    //通过responseId拿到block，responseCallbacks是存储_doSend方法中的block
                    responseCallback = responseCallbacks[message.responseId];
                    if (!responseCallback) {
                        return;
                    }
                    //执行block
                    responseCallback(message.responseData);
                    delete responseCallbacks[message.responseId];
                } else {
                    if (message.callbackId) {
                        var callbackResponseId = message.callbackId;
                        responseCallback = function(responseData) {
                            _doSend({ handlerName:message.handlerName, responseId:callbackResponseId, responseData:responseData });
                        };
                    }
                    //根据oc传进来的名称来回调html中的js代码
                    var handler = messageHandlers[message.handlerName];
                    if (!handler) {
                        console.log("WebViewJavascriptBridge: WARNING: no handler for message from ObjC:", message);
                    } else {
                        handler(message.data, responseCallback);
                    }
                }
            }
        }
        
        function _handleMessageFromObjC(messageJSON) {
            _dispatchMessageFromObjC(messageJSON);
        }
        
        messagingIframe = document.createElement('iframe');
        messagingIframe.style.display = 'none';
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
        document.documentElement.appendChild(messagingIframe);
        
        registerHandler("_disableJavascriptAlertBoxSafetyTimeout", disableJavscriptAlertBoxSafetyTimeout);
        
        setTimeout(_callWVJBCallbacks, 0);
        function _callWVJBCallbacks() {
            var callbacks = window.WVJBCallbacks;
            delete window.WVJBCallbacks;
            for (var i=0; i<callbacks.length; i++) {
                //这里是用来调用html中的闭包
                callbacks[i](TYImitationWebMeson);
            }
        }
    })();
                                                             ); // END preprocessorJSCode
    
#undef __wvjb_js_func__
    return preprocessorJSCode;
};
