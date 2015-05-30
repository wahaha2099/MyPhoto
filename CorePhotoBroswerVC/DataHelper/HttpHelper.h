//
//  DataHelper.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

+(instancetype) Instance;

//请求,回调消息
-(void) request:(NSString*)url notify:(NSString*)notify isJson:(bool)isJson;

@end
