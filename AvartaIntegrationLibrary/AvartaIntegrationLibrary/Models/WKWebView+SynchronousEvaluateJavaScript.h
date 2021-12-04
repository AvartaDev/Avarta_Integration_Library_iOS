//
//  WKWebView+SynchronousEvaluateJavaScript.h
//  AvartaIntegrationLibrary
//
//  Created by plusinfosys on 05/07/21.
//  Copyright © 2021 Dmitrii Babii. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (SynchronousEvaluateJavaScript)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
@end

NS_ASSUME_NONNULL_END
