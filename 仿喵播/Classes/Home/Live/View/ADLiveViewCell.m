//
//  ADLiveViewCell.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADLiveViewCell.h"
#import "ADBottomToolView.h"
#import "ADLiveAnchorView.h"
#import "ADCatEarView.h"
#import "ADInLive.h"
#import "ADUser.h"
#import "UIImage+ADExtension.h"
#import "ADLiveEndView.h"
#import <SDWebImageDownloader.h>
#import <BarrageRenderer.h>
#import "NSSafeObject.h"

/**
 
    先设置底部工具栏，通过ADBottomToolView来初始化设置。
    控件的宽度固定，间距为自动计算，通过ImageView展示内容并开启用户交互
    通过自定义添加的手势来响应图片的点击事件，imageView以tag值区分
    点击事件中通过block来调用当前控制器中设置的响应事件
    目前只有close和publicTalk(弹幕)有响应事件执行,其余为空
    通过insert: aboveSubView: 将其置于placeHolderView之上
    弹幕使用的是BarrageRenderer框架,通过direction设置最大数量

    placeHolderView如果没有GIF展示，就展示一组默认image
    通过自定义ViewController延展类中对象方法howGifLoding: inView: 完成
    具体操作为若传来的image数组为空，则设置一组默认数组
    若传来的View为空，则为当前控制器的View 
    而后通过ImageView的延展类中对象方法playGifAnim播放
    具体播放为通过ImageView的animationImages设置imageArr
    通过ImageView的animationDuration设置播放一次的时间
    通过ImageView的animationRepeatCount设置播放次数,0为无限
    而后通过startAnimating 和 stopAnimating开始\暂停播放
 
    NSSafeObject就是通过初始化绑定一个对象与一个方法执行操作
    在初始化中通过此方法与NSTimer结合使得每过0.5秒就当前对象限制一下弹幕数量<=50
 
    通过对cell的live(主播的相关信息数据)设置，而调用anchorView并设置live
    通过anchorView(顶部主播相关视图)的点语法来生成一个UIView视图
   
    每个anchorView都保存有主播user(chaoyangUser)、直播live的相关视图与点击开关
    通过maskToBounds来设置圆角信息,layer设置边框
    主播头像右侧的关联头像图标，就是通过传过去的user设置，用scrollView展示
    通过注册的点击手势设置点击事件,点击事件中发布一个通知，附带点击的用户详细信息
    关闭按钮以Block调用事件，默认是关闭的
    通过live获取到直播数据,在set方法中展示就进行展示,在线人数与猫粮娃娃皆是随机生成
    并通过NSTimer设置为1.0秒更新一次,头像的点击事件与右侧关联头像图标为同一事件
 
    anchorView生成之后通过block响应关闭的点击事件来控制直播播放器的  
    shouldShowHudView(右侧详细信息)是否开启,默认是关闭的。
    通过insert插入到placeHolder上
    
    当设置了Cell的live信息后，就开始播放。通过plarFLV: placeHolderUrl:方法
    前者为播放的flv，后者为播放时的placeHolderView.image的地址
    每次播放时，都将上一次的播放shutdown并移除，粒子特效移除并置空
    同类型直播视图移除，并从控制中心移除对自己的监听
 
    而后从新设置IJK的options与Player(options设置音量、帧速率、声音视频的播放模式等,player则为controllor负责flv的播放与播放模式、HudView等)
    并prepareToPlayer,设置播放器的监听
    显示工会其他主播/类似主播(otherView)，开启粒子特效(EmitterLayer)
    其中otherView与EmitterLayer都是点语法生成
    otherView添加点击手势来响应点击事件
    粒子特效使用CAEmitterLayer框架，通过image显示内容
    添加到moviePlayer的layer层上
 
    关联主播即为位于当前列表主播的下一个主播，若当前主播为最后一个主播
    则下一个主播即为第一个主播，通过外界赋值获取数据，重写set方法显示catEarView
    如果相关主播值为nil，就隐藏catEarView
    
    catEarView(ADCatEarView)通过options设置只播放视频没有声音且自动播放
    而后通过播放控制器播放，圆角为自身View的mask.
    需注意，要重写removeFromSuperView,判断播放器存在时应先关闭remove而后置空
    对于关联主播的点击事件则通过block调用写在控制器里的事件

    当播放器的播放状态发生改变时
    如果是自动播放,并当前控制器没有播放时则开启播放(如网络状态不好暂停后恢复)
    并于一秒后移除placeHolderView,添加弹幕,隐藏父控制器的GIF
    如果正在播放状态则隐藏父控制器的GIF
    如果是网络不佳正在加载状态就让父控制器显示GIF
    所以若网络状态不好, 断开后恢复, 也需要去掉加载
    播放结束时需判断若因为网速或者其他原因导致直播stop了而且GIF没有显示
    则也要显示GIF,存在状态如暂停状态后直接stop,所以自动暂停时不需要判断
    而后从新获取直播flv数据开始播放,若获取失败则关闭移除播放器并置空
 
 */


@interface ADLiveViewCell()
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
}
//直播播放器
@property(nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
//底部的工具栏
@property(nonatomic, weak) ADBottomToolView *toolView;
//顶部主播相关视图
@property(nonatomic, weak) ADLiveAnchorView *anchorView;
//同类型直播视图
@property(nonatomic, weak) ADCatEarView * catEarView;
//同一个工会的主播/相关主播
@property(nonatomic, weak) UIImageView *otherView;
//直播开始前的占位图片
@property(nonatomic, weak) UIImageView *placeHolderView;
//粒子动画
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
//直播结束的界面
@property(nonatomic, weak) ADLiveEndView *endView;

@end

@implementation ADLiveViewCell

-(UIImageView *)placeHolderView{
    
    if (!_placeHolderView) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = self.contentView.bounds;
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.contentView addSubview:imageView];
        _placeHolderView = imageView;
        [self.parentVc showGifLoding:nil inView:self.placeHolderView];
        //强制布局
        [_placeHolderView layoutIfNeeded];
    }
    
    return _placeHolderView;
}


bool _isSelected = NO;
-(ADBottomToolView *)toolView{
    
    if (!_toolView) {
        
        ADBottomToolView *toolView = [[ADBottomToolView alloc] init];
        
        [toolView setClickToolBlock:^(LiveToolType type) {
            
            switch (type) {
                    
                case LiveToolTypePublicTalk:
                    _isSelected = !_isSelected;
                
                    _isSelected ? [_renderer start] : [_renderer stop];
                    break;
                    
                case LiveToolTypePrivateTalk:
                    break;
                    
                case LiveToolTypeGift:
                    break;
                    
                case LiveToolTypeRank:
                    break;
                    
                case LiveToolTypeShare:
                    break;
                    
                case LiveToolTypeClose:
                    [self quit];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self.contentView insertSubview:toolView aboveSubview:self.placeHolderView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@40);
            
        }];
        _toolView = toolView;
    }
    
    
    return _toolView;
}


-(void)quit{
   
    if (_catEarView) {
        [_catEarView removeFromSuperview];
        _catEarView = nil;
    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
    
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
    
    [self.parentVc dismissViewControllerAnimated:YES completion:nil];
    
}



-(UIImageView *)otherView{
    
    if (!_otherView) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
        [self.moviePlayer.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.catEarView);
            make.bottom.equalTo(self.catEarView.mas_top).offset(-40);
        }];
        _otherView = imageView;
        
    }
    
    return _otherView;
}

-(void)clickOther{
    NSLog(@"相关的主播");
}

-(ADLiveAnchorView *)anchorView{
    
    if (!_anchorView) {
        ADLiveAnchorView *anchorView = [ADLiveAnchorView liveAnchorView];
        [anchorView setClickDeviceShow:^(BOOL isSelected) {
            if (_moviePlayer) {
                _moviePlayer.shouldShowHudView = !isSelected;
            }
        }];
        [self.contentView insertSubview:anchorView aboveSubview:self.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@120);
            make.top.equalTo(@120);
        }];
        _anchorView = anchorView;
    }
    
    return _anchorView;
}

-(ADCatEarView *)catEarView{
    
    if (!_catEarView) {
        
        ADCatEarView *catEarView = [ADCatEarView catEarView];
        catEarView.layer.masksToBounds = YES;
        [self.moviePlayer.view addSubview:catEarView];
        [catEarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCatEar)]];
        [catEarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.moviePlayer.view);
            make.width.height.equalTo(@98);
        }];
        _catEarView = catEarView;
    }
    
    return _catEarView;
}

-(void)clickCatEar{
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
}

-(CAEmitterLayer *)emitterLayer{
    
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        //发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width - 50, self.moviePlayer.view.frame.size.height - 50);
        //发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        //渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        //开启三维效果
        emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        
        //创建粒子
        for (int i = 0; i < 10; i++) {
            //发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            //粒子的创建速率,默认为1/s
            stepCell.birthRate = 1;
            //粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            //粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30",i]];
            //粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            //粒子的名字
            stepCell.velocity = arc4random_uniform(100) + 100;
            //粒子速度的容差
            stepCell.velocityRange = 80;
            //粒子在xy平面的发射角落
            stepCell.emissionLongitude = M_PI + M_PI_2;
            //粒子发射角度的容差
            stepCell.emissionRange = M_PI_2 / 6;
            //缩放比例
            stepCell.scale = 0.3;
            
            [array addObject:stepCell];
            
            emitterLayer.emitterCells = array;
            [self.moviePlayer.view.layer insertSublayer:emitterLayer below:self.catEarView.layer];
            _emitterLayer = emitterLayer;
        }
    }
    
    return _emitterLayer;
}

-(ADLiveEndView *)endView{
    
    if (!_endView) {
        
        ADLiveEndView *endView = [ADLiveEndView liveEndView];
        [self.contentView addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [endView setQuitBlock:^{
            [self quit];
        }];
        [endView setLookOtherBlock:^{
            [self clickCatEar];
        }];
        _endView = endView;
    }
    
    return _endView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.toolView.hidden = NO;
        
        _renderer = [[BarrageRenderer alloc] init];
        _renderer.canvasMargin = UIEdgeInsetsMake(ALinScreenHeight * 0.3, 10, 10, 10);
        [self.contentView addSubview:_renderer.view];
        
        NSSafeObject *safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

-(void)autoSendBarrage{
    
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    
    //限制屏幕上的弹幕量
    if (spriteNumber <= 50) {
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}


#pragma mark - 弹幕描述生产方法
//生成精灵描述 - 过场文字弹幕
long _index = 0;
-(BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction {
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((u_int32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random() / RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
  
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    };
    
    
    return descriptor;
}



-(NSArray *)danMuText{
    
    
    
    
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];

}

-(void)setLive:(ADInLive *)live{
    _live = live;
    self.anchorView.live = live;
    [self plarFLV:live.flv placeHolderUrl:live.bigpic];
}

-(void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl{
    
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }if (_catEarView) {
            [_catEarView removeFromSuperview];
            _catEarView = nil;
        }
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    //如果切换主播,取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
  
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.parentVc showGifLoding:nil inView:self.placeHolderView];
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
        
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    //-vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc]initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = self.contentView.bounds;
    
    //填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    //设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    //默认不显示
    moviePlayer.shouldShowHudView = NO;

    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
 
    self.moviePlayer = moviePlayer;
        // 设置监听
        [self initObserver];
   
 
    
    //  显示工会其他主播和类似主播
    [moviePlayer.view bringSubviewToFront:self.otherView];
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}


-(void)initObserver{
    //监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification  object:self.moviePlayer];
    
}

-(void)stateDidChange{
    //自动播放
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK)!=0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVc hideGufLoding];
            });
            
        }else{
           
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGufLoding];
                });
            }
        }
    } else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态,所以若网络状态不好, 断开后恢复, 也需要去掉加载
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        
    }
    
}


-(void)didFinish{
     NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    //因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束

    __weak typeof(self)weakSelf = self;
    [[ADNetWorkTool shareTool] GET:self.live.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@，等待继续播放",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        weakSelf.endView.hidden = NO;
    }];
    
}

-(void)setRelateLive:(ADInLive *)relateLive{
    
    _relateLive = relateLive;
    //设置相关主播
    if (relateLive) {
        self.catEarView.live = relateLive;
    }else{
        self.catEarView.hidden = YES;
    }
    
}





@end
