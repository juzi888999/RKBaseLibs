//
//  HPResponseEntity.h
//  RKBaseLibs
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPEntity.h"

@interface HPResponseHeadEntity : HPEntity
@property (copy,nonatomic) NSString * stateInfo;
@property (copy,nonatomic) NSString * code;
@property (copy,nonatomic) NSString * httpurl;
@property (copy,nonatomic) NSString * timestamp;
@property (copy,nonatomic) NSString * version;
@property (copy,nonatomic) NSString * token;
@property (copy,nonatomic) NSString * info;
@property (copy,nonatomic) NSString * state;
@property (copy,nonatomic) NSString * flag;
@end

@interface HPResponseEntity : HPEntity

/* {"data":"eyJleHRlbnNpb25Ob3RpY2VJbmZvTGlzdCI6W3siY29udGVudCI6IjxwPmRlZGVkZWRlZGVkZWRlZGU8L3A+IiwiY29udGVudFR4dCI6ImRlZGVkZWRlZGVkZWRlZGUiLCJjcmVhdGVkRGF0ZSI6MTU0MzI5OTQ5ODAwMCwiY3JlYXRlZFVzZXIiOiJhZG1pbiIsImlkIjo5LCJpbmRleCI6MCwiaXNEZWxldGUiOjAsImxhc3RNb2RpZmllZERhdGUiOjE1NDM2NDExMTUwMDAsImxhc3RNb2RpZmllZFVzZXIiOiJhZG1pbiIsImxpbmsiOiIxIiwic2l6ZSI6MCwic29ydCI6MCwic3RhdHVzIjoxLCJ0aGVtZSI6ImhlbGxvIiwidGhlbWV0eXBlIjowLCJ0eXBlIjozfSx7ImNvbnRlbnQiOiI8cD5yenExMzIyMzwvcD4iLCJjb250ZW50VHh0IjoicnpxMTMyMjMiLCJjcmVhdGVkRGF0ZSI6MTU1MjAzNzA4MjAwMCwiY3JlYXRlZFVzZXIiOiJhZG1pbiIsImlkIjoxMywiaW5kZXgiOjAsImlzRGVsZXRlIjowLCJsYXN0TW9kaWZpZWREYXRlIjoxNTUyMDM3MTYzMDAwLCJsYXN0TW9kaWZpZWRVc2VyIjoiYWRtaW4iLCJsaW5rIjoiMTEiLCJzaXplIjowLCJzb3J0IjowLCJzdGF0dXMiOjEsInRoZW1lIjoicnpxIiwidGhlbWV0eXBlIjowLCJ0eXBlIjozfV0sIm1lc3NhZ2UiOiJzdWNjZXNzIiwic3RhdHVzIjoic3VjY2VzcyJ9","head":{"stateInfo":"操作成功","code":"00","httpurl":"http://103.246.113.176:9999/duoduoWeb/","timestamp":"1553065538700","version":"1.0","token":"3fec366c341bc7390b4c55b666434098","info":"正确返回","state":"true"}}
 
 {"data":"eyJtZXNzYWdlIjoidG9rZW7moKHpqozlpLHotKXvvIEiLCJzdGF0dXMiOiJmYWlsIn0=","head":{"code":null,"info":"token校验失败！","timestamp":null,"version":null,"token":null,"httpurl":null}}
 */

@property (copy,nonatomic) NSString * data;
@property (strong,nonatomic) NSDictionary * dataDic;//通过data base64解密得来
@property (strong, nonatomic) HPResponseHeadEntity *head;
@property (strong,nonatomic) AFHTTPRequestOperation * op;


@property (strong,nonatomic) id result;
@property (copy,nonatomic) NSString * msg;
@property (copy,nonatomic) NSString * status;
@property (copy,nonatomic) NSString * code;

@end
