//
//  OpenURLManager.m
//
//  Created by rk on 14-11-30.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "OpenURLManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation OpenURLManager

+(BOOL)openUrl:(NSString *)url
{
    BOOL open = NO;
    UIApplication *app = [UIApplication sharedApplication];
    NSString * urlString = [NSString checkString:url];
    if ([app canOpenURL:[NSURL URLWithString:urlString]]){        
        open = [app openURL:[NSURL URLWithString:urlString]];
    }
    return open;
}

+ (void)callTelephoneWithNumber:(NSString *)number
{
    if ([NSString checkString:number].length == 0) return;
    UIApplication *app = [UIApplication sharedApplication];
    NSString * urlString = [NSString stringWithFormat:@"tel:%@", number];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([app canOpenURL:url])
        [app openURL:url];
}

+ (void)promptCallTelephoneWithNumber:(NSString *)number
{
    if ([NSString checkString:number].length == 0) return;
    UIApplication *app = [UIApplication sharedApplication];
    NSString * urlString = [NSString stringWithFormat:@"telprompt:%@", number];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([app canOpenURL:url])
        [app openURL:url];
}

+ (void)webViewCallTelephoneWithNumber:(NSString *)number
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",number];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}

+ (BOOL)canOpenBaiduMap
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]];
}

+ (void)openBaiduMapWithAddress:(NSString *)address
{
    if (![OpenURLManager canOpenBaiduMap]) return;
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    //    NSString *urlScheme = appScheme;
    NSString *gaodeParameterFormat = @"baidumap://map/direction?destination=%@&mode=driving";
    NSString *urlString = [[NSString stringWithFormat:
                            gaodeParameterFormat,
                            address]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}
+ (BOOL)canOpenIOSAmapMap
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]];
}
+ (void)openIOSAmapMapWithAddress:(NSString *)address
{
    if (![OpenURLManager canOpenIOSAmapMap]) return;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    //    NSString *urlScheme = appScheme;
    
    NSString *gaodeParameterFormat = @"iosamap://path?sourceApplication=%@&dname=%@&dev=0&t=0";
    NSString *urlString = [[NSString stringWithFormat:
                            gaodeParameterFormat,
                            appName,
                            address]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+ (void)openIOSAmapSystemWithAddress:(NSString *)address
{
    NSString *oreillyAddress = address;//@"北京市东城区东单";
    
    //下边就是利用CLGeocoder把地理位置信息转换成经纬度坐标；
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray*placemarks,NSError *error) {
        
        //placemarks就是转换成坐标的数组(当地理位置信息不够准确的时候可能会查询出来几个坐标);
        if ([placemarks count] >0 && error ==nil){
            
            NSLog(@"%lu ", (long)[placemarks count]);
            NSMutableArray *arrtemp=[[NSMutableArray alloc]initWithCapacity:0];
            
            for (int i=0; i<[placemarks count]; i++) {
                CLPlacemark *firstPlacemark = [placemarks objectAtIndex:i];
                //查看CLPlacemark这个类可以看到里边有很多属性；位置的名称等。
                
                //下面就是来调用苹果地图应用了；
                MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude,firstPlacemark.location.coordinate.longitude)addressDictionary:nil]];
                toLocation.name = firstPlacemark.name;
                
                [arrtemp addObject:toLocation];
            }
            //打开地图
            //1.搜索位置；
            //[MKMapItem openMapsWithItems:arrtemp launchOptions:nil];
            //2.查询线路；
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];//当前位置
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithCapacity:0];
            [dict setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
            [dict setObject:[NSNumber numberWithBool:YES]forKey:MKLaunchOptionsShowsTrafficKey];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, [arrtemp objectAtIndex:0],nil]launchOptions:dict];
            //MKLaunchOptionsDirectionsModeKey方式:步行，开车
            //MKLaunchOptionsShowsTrafficKey  显示交通状况
            //MKMapItem 进去后看其他属性
        }
        else if ([placemarks count] ==0 &&
                 error ==nil){
            NSLog(@"Found no placemarks.");
            [UIGlobal showMessage:@"找不到此位置"];
        }
        else if (error !=nil){
            NSLog(@"An error occurred = %@", error);
            //            [UIGlobal showMessage:error.localizedDescription];
            [UIGlobal showMessage:@"找不到此位置"];
        }
    }];
}

/**
 @param coordinate 经纬度字符串@"118.0000,24.0000"
 @param name 地点名称
 */
+ (void)gohereWithCoordinate:(NSString *)coordinate name:(NSString *)name
{
    NSString * coordinateStr = [NSString checkString:coordinate];
    NSArray * arr = [coordinateStr componentsSeparatedByString:@","];
    if (arr.count != 2) {
        [UIGlobal showMessage:@"经纬度数据错误"];
        return;
    }
    //起点
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //终点
    CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake([arr[1] doubleValue],[arr[0]doubleValue]);
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
    toLocation.name = name;
    //默认驾车
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],
                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}

//谷歌地图
+ (BOOL)canOpenGoogleMap
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://map/"]];
}
+ (void)openGoogleMapWithAddress:(NSString *)address
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *urlScheme = appScheme;
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",
                            appName,
                            urlScheme,
                            @"",
                            @""]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(BOOL)isWeChatInstall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])    {
        return YES;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])    {
        return YES;
    }
    return NO;
}

@end
