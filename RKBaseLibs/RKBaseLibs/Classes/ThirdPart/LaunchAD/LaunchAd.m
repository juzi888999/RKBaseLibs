//
//  LaunchAd.m
//  RKBaseLibs
//
//  Created by rk on 2017/12/25.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "LaunchAd.h"
#import "BaseWebViewController.h"
#import "MAdvertisementModel.h"

@interface CycleProgressView : UIView
@property (assign,nonatomic) CGFloat progress;
@end

@implementation CycleProgressView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center = CGPointMake(self.width/2.f, self.height/2.f);
    CGFloat radius = self.width/2.f;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 1.5); //设置线条宽度
    [HPColorForKey(@"main") setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}
@end

@implementation LaunchAdEntity

-(instancetype)initRandom
{
    if (self = [super initRandom]) {
        self.apd_filepath = @"http://test.gzrbs.com.cn:100/data/upload/advert/2017/12/25/05675397733468039.png";
        self.apd_time = @"3";
        self.apd_linkUrl = @"http://www.baidu.com";
    }
    return self;
}
@end

@interface LaunchAd()
@property (assign,nonatomic) NSInteger currentIndex;
@property (strong,nonatomic) MAdvertisementModel * model;
@end
@implementation LaunchAd

-(instancetype)init{
    if (self = [super init]) {
        self.model = [[MAdvertisementModel alloc]init];
        MAdvertisementRequest * req = [[MAdvertisementRequest alloc]init];
        req.location = @"1";
        self.model.request = req;
        
        self.rootViewController = [[ADRootViewController alloc]init];
        BaseNavigationViewController * baseNav = [[BaseNavigationViewController alloc]initWithRootViewController:_rootViewController];
        self.rootNavigationController = baseNav;
        self.currentTime = 0;
        self.currentIndex = 0;
        self.currentFloatTime = 0.f;
        self.imageViewArray = [NSMutableArray array];
        [self initBaseView];
    }
    return self;
}

- (void)requestLaunchAdSuccess:(HPSuccess)success failure:(HPFailure)failure
{
    [self startTimer];
    @weakify(self);
    [self.model loadDataWithBlock:^(NSArray *arr, NSError *error) {
        @strongify(self);
        if (self) {
            [self stopTimer];
            if (!error) {
                MAdvertisementEntity * object = arr.firstObject;
                if (object) {
                    NSArray * images = [[NSString checkString:object.img] componentsSeparatedByString:@","];
                    NSArray * links = [[NSString checkString:object.href] componentsSeparatedByString:@","];
                    NSMutableArray * temp = [NSMutableArray array];
                    for (int i = 0; i<images.count; i++) {
                        LaunchAdEntity * entity = [[LaunchAdEntity alloc]init];
                        entity.apd_time = @"3";
                        entity.apd_name = object.title;
                        entity.apd_filepath = [NSString checkString:images[i]];
                        if (links.count > i) {
                            entity.apd_linkUrl = [NSString checkString:links[i]];
                        }
                        [temp addObject:entity];
                    }
                    self.adList = temp;
                }
                if (success) {
                    success(self.adList);
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }
    } more:NO refresh:YES];
    
//    self.op = [[NetworkClient sharedInstance] getWithPath:nil params:nil success:^(HPResponseEntity * responseObject) {
//        @strongify(self);
//        if (self) {
//            NSLog(@"%@",responseObject.result);
//            NSArray * adList = [NSArray checkArray:responseObject.result[@"ads_list"]];
//            self.adList = [MTLJSONAdapter modelsOfClass:[LaunchAdEntity class] fromJSONArray:adList error:nil];
//
//            //        weakself.adList = @[[[LaunchAdEntity alloc]initRandom],[[LaunchAdEntity alloc]initRandom],[[LaunchAdEntity alloc]initRandom]];
//            [self stopTimer];
//            if (success) {
//                success(self.adList);
//            }
//        }
//
//    } failure:^(NSError *error) {
//        @strongify(self);
//        if (self) {
//            NSLog(@"%@",error);
//            if (failure) {
//                failure(error);
//            }
//            [self stopTimer];
//        }
//    }];
}

- (void)stopTimer
{
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.progressTimer && [self.progressTimer isValid]) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)showADsInView:(UIView *)superView
{
    [superView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superView);
    }];
    
    int i = 100;
    int totalTime = 0 ;
    for (LaunchAdEntity * object in self.adList) {
        totalTime += [object.apd_time integerValue];
    }
    self.totalTime = totalTime;
    self.currentTime = 0;
    [self.imageViewArray removeAllObjects];
    for (LaunchAdEntity * object in self.adList) {
        self.currentTime += [object.apd_time integerValue];
        object.removeTime = totalTime - self.currentTime;
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        NSURL * url = [NetworkClient imageUrlForString:object.apd_filepath];
        [imageV sd_setImageWithURL:url placeholderImage:nil];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageV addGestureRecognizer:tap];
        imageV.tag = i;
        [self.imageViewArray addObject:imageV];
        [self.baseView insertSubview:imageV atIndex:0];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.baseView);
        }];
        i ++;
    }
    [self addEnterBtn];
    [self startTimer];
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 100;
    LaunchAdEntity * object = self.adList[index];
    if ([NSString checkString:object.apd_linkUrl].length == 0) {
        return;
    }
    SSWebViewController * vc = [[SSWebViewController alloc]init];
    vc.url = [NSString checkString:object.apd_linkUrl];
    vc.title = object.apd_name;
//    [self.rootNavigationController presentViewController:vc animated:YES completion:NULL];
    [self.rootNavigationController pushViewController:vc animated:YES];
    [self stopTimer];
    @weakify(self);
    [self.rootViewController setAd_viewDidAppearBlock:^{
        @strongify(self);
        if (self) {
            /*
            //进入广告详情之后回来继续看下一条广告
            [self startTimer];
            */
            
            //进入广告详情之后回来进入app首页
            if (self.enterBtnAction) {
                self.enterBtnAction(YES);
            }
        }
    }];
    if (self.imageViewDidTap) {
        self.imageViewDidTap(object);
    }
}

- (void)updateProgress
{
    self.currentFloatTime += 0.1f;
    if (self.type == LaunchAdTypeTotalTime) {
        self.progressView.progress = self.currentFloatTime*1.f/self.totalTime;
    }else if (self.type == LaunchAdTypeSignleTime){
        LaunchAdEntity * object = self.adList[self.currentIndex];
        self.progressView.progress = self.currentFloatTime*1.f/[object.apd_time integerValue];
    }
}

- (void)updateTime
{
    //如果正在请求广告数据,时间进度继续走,3秒后仍然没有请求成功数据则当做广告无效
    if (self.model.op.isExecuting) {
        self.currentTime += 1;
    }else{
        if (self.currentTime > 0) {
            self.currentTime --;
        }
    }
    if (self.model.op.isExecuting && self.currentTime == 3) {
        [self stopTimer];
        [self.model cancelRequstOperation];
        if (self.enterBtnAction) {
            self.enterBtnAction(YES);
        }
    }else if (self.adList.count > 0) {
//        [self.enterBtn setTitle:@(self.currentTime).stringValue forState:UIControlStateNormal];
        if (self.enterBtnAction) {
            if (self.currentTime == 0) {
                [self stopTimer];
            }
            self.enterBtnAction(self.currentTime == 0);
        }
        for (int i = 0; i < self.adList.count; i++) {
            LaunchAdEntity * object = self.adList[i];
            if (object.removeTime == self.currentTime) {
                self.currentIndex = i+1;
                if (self.type == LaunchAdTypeSignleTime){
                    self.currentFloatTime = 0.f;
                }
                UIImageView * imageV = self.imageViewArray[i];
                if (imageV.superview) {
                    [imageV removeFromSuperview];
                }
            }
        }
    }
}

- (void)initBaseView
{
    self.baseView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.baseView.backgroundColor = [UIColor whiteColor];
}

- (void)addEnterBtn
{
    CycleProgressView * progressView = [[CycleProgressView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    progressView.layer.cornerRadius = 35.f/2.f;
    progressView.layer.masksToBounds = YES;
    self.progressView = progressView;
    progressView.progress = 1.f;
    progressView.backgroundColor = HPColorForKey(@"#ffffff");
    [self.baseView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterBtn = button;
//    [button setTitle:@(self.currentTime).stringValue forState:UIControlStateNormal];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    button.titleLabel.font = HPFontWithSize(12);
    [button setBackgroundColor:HPColorForKey(@"main")];
    [button setTitleColor:HPColorForKey(@"#ffffff") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    [progressView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(progressView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    button.layer.cornerRadius = 16;
    button.layer.masksToBounds = YES;
}

- (void)enterAction:(UIButton *)sender
{
    
//#if DEBUG
//    BOOL canEnter = YES;
//#else
//    BOOL canEnter = self.currentTime == 0;
//#endif
    if (self.type == LaunchAdTypeTotalTime) {
        if (self.enterBtnAction) {
            [self stopTimer];
            self.enterBtnAction(YES);
        }
    }else if (self.type == LaunchAdTypeSignleTime){
        
        if (self.currentIndex >= self.adList.count-1) {
            if (self.enterBtnAction) {
                [self stopTimer];
                self.enterBtnAction(YES);
            }
        }else{
                [self nextOne];
        }
    }
}

- (void)nextOne
{
    LaunchAdEntity * object = self.adList[self.currentIndex];
    self.currentTime = object.removeTime+1;
    [self updateTime];
}

-(void)dealloc
{
    NSLog(@"");
}

@end
