//
//  DataHelper.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//

#import "HttpHelper.h"

@implementation HttpHelper

static HttpHelper * helper ;

+(instancetype) Instance{
    if( helper == nil){
        helper = [[HttpHelper alloc] init];
    }
    return helper;
}

-(void) request:(NSString*)url notify:(NSString*)notify isJson:(bool) isJson{

    NSURLRequest * request = [self HTTPGETRequestForURL:url parameters:nil isJson:isJson];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    __block NSMutableData* xmlData = [[NSMutableData alloc] init];
    
    //建立连接（异步的response在专门的代理协议中实现）
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   xmlData = nil;
                                   NSLog(@"error:%@", error.localizedDescription);
                               }
                               NSLog(@"receive data ~");
                               [xmlData appendData:data];
                               
                               //NSString * rsp = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
                               //NSLog(@"receive data %@" , rsp);
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:notify object:xmlData userInfo:nil];
                           }];
}

- (NSURLRequest *)HTTPGETRequestForURL:(NSString *)URL parameters:(NSDictionary *)parameters isJson:(bool)isJson
{
    NSURL *url=[NSURL URLWithString:URL];

    NSURL *finalURL = url;
    if(parameters != nil){
        NSString *URLFellowString = [@"?"stringByAppendingString:[self HTTPBodyWithParameters:parameters]];
        NSString *finalURLString = [[url.absoluteString stringByAppendingString:URLFellowString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        finalURL = [NSURL URLWithString:finalURLString];
    }
    
    int TIME_OUT_INTERVAL = 20;
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT_INTERVAL];
    [URLRequest setHTTPMethod:@"GET"];
    
    if(isJson){
        [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [URLRequest setValue:@"huaban.com" forHTTPHeaderField:@"Host"];
        [URLRequest setValue:@"http://huaban.com/" forHTTPHeaderField:@"Referer"];
        [URLRequest setValue:@"JSON" forHTTPHeaderField:@"X-Request"];
        [URLRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [URLRequest setValue:@"_hmt2=1; _dc=1;sid=5Jvkbfx8h4mU0ZKpXIFTIeC8.cbsxUghDo3YwLIjGRSGFzKQ1K1FoWH7a9RwIyDMJpuM; _ga2=GA1.2.2003196218.1428032843; __asc2=2acf350114db2c52c2f1835f35b; __auc=df91d1df14c7d63ef1865537567" forHTTPHeaderField:@"Cookie"];
        
    }
    return URLRequest;
    
}

- (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

/*
 Accept:application/json
 Accept-Encoding:gzip, deflate, sdch
 Accept-Language:zh-CN,zh;q=0.8,en;q=0.6
 Connection:keep-alive
 Cookie:_hmt=1; _dc=1; _dc_adsTracker=1; _ga=GA1.2.2003196218.1428032843; __asc=fba54ec014d98accdc89bbb2204; __auc=df91d1df14c7d63ef1865537567; uid=17015367; sid=5Jvkbfx8h4mU0ZKpXIFTIeC8.cbsxUghDo3YwLIjGRSGFzKQ1K1FoWH7a9RwIyDMJpuM
 Host:huaban.com
 Referer:http://huaban.com/boards/19659085
 User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36
 X-Request:JSON
 X-Requested-With:XMLHttpRequest
 */


@end
