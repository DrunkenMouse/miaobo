//
//  ADLoginViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/21.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADThirdLoginView.h"
#import "MainViewController.h"



@interface ADLoginViewController ()

//第三方登录
@property(nonatomic, weak) ADThirdLoginView *thirdView;
//快速通道
@property(nonatomic, weak) UIButton *quickBtn;
//封面图片
@property(nonatomic, weak) UIImageView *coverView;
//player
@property(nonatomic, strong) IJKFFMoviePlayerController *player;


@end

@implementation ADLoginViewController


/**
    播放器使用IJK,通过懒加载方式创建
    创建时就随机播放一个视频，当作背景图
    播放结束后就重新播放
    通过给播放器的View添加一个View达到播放时先显示图片
    随后显示视频的播放效果
    先添加播放器的View到自身View上
    再添加按钮、第三方登录页面到自身View上
    达到底部是播放，上面挂载显示
 */
#pragma mark - 懒加载设置属性

//通过懒加载创建一个播放器，用于随时播放
-(IJKFFMoviePlayerController *)player{
    if (!_player) {
        //随机播放一组视频
        NSString *path = arc4random_uniform(10)%2 ? @"login_video" : @"loginmovie";
        
        IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        
        //设置player
        player.view.frame = self.view.bounds;
        //填充fill
        player.scalingMode = IJKMPMovieScalingModeAspectFill;
        [self.view addSubview:player.view];
        //设置自动播放
        player.shouldAutoplay = NO;
        //准备播放
        [player prepareToPlay];
        
        _player = player;
    }
    return _player;
}


//第三方登录页面
-(ADThirdLoginView *)thirdView{
    
    if (!_thirdView) {
        //创建一个第三方登录页面
        ADThirdLoginView *third = [[ADThirdLoginView alloc]initWithFrame:CGRectMake(0, 0, 400, 200)];
        //通过Block传值获取一个type,然后执行相应的任务
        [third setClickLogin:^(LoginType type) {
            [self loginSuccess];
        }];
        //默认是隐藏的
        third.hidden = YES;
        [self.view addSubview:third];
        _thirdView = third;
    }
    return _thirdView;
}


//快速登录按钮
-(UIButton *)quickBtn{
    if (!_quickBtn) {
     
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [UIColor yellowColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:@"AD快速通道" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        //点击快速登录后调用登录成功方法
        [btn addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        //默认也是隐藏的
        btn.hidden = YES;
        _quickBtn = btn;
        
    }
    return _quickBtn;
}

//封面图片
-(UIImageView *)coverView{
    if (!_coverView) {
        
        UIImageView *cover = [[UIImageView alloc]initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        //给播放器界面添加一个图片
        //播放器会先显示图片在显示播放内容
        [self.player.view addSubview:cover];
        _coverView = cover;
    }
    return _coverView;
}




//View将要销毁时停止播放
//并从通知中心移除对自身的监听
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.player shutdown];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

//View已经销毁时移除播放器并置为空
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self.player.view removeFromSuperview];
    self.player =nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

-(void)setup{
    
    [self initObserver];
    self.view.backgroundColor = [UIColor whiteColor];
    //令播放器的封面显示出来
    self.coverView.hidden = NO;
    
    [self.quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.bottom.equalTo(@-60);
        make.height.equalTo(@40);
    }];
    
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.quickBtn.mas_top).offset(-40);
    }];
    
}


#pragma mark - 给自身注册监听,监听播放是否完成
-(void)initObserver{
    
    //监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //视频加载状态是否改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
    
}


//播放状态改变时
-(void)stateDidChange{
    //如果是播放状态，并且是从后台返回的时候会自动播放状态
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK)!=0)  {
       //则视频没有播放就手动开启播放
        if (!self.player.isPlaying) {
            self.coverView.frame = self.view.bounds;
            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            //播放0.4s后显示快速通道按钮与第三方登录View
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.thirdView.hidden = NO;
                self.quickBtn.hidden = NO;
            });
        }
    }
}

//播放完后继续重播
-(void)didFinish{
    
    [self.player play];
}



//登录成功
-(void)loginSuccess{
    //显示成功提示
    [self showHit:@"登录成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //一秒钟后，主队列刷新UI
        //present新的View,停止播放器播放
        //并移除置为空
      [self presentViewController:[[MainViewController alloc] init] animated:NO completion:^{
        
          [self.player stop];
          [self.player.view removeFromSuperview];
          self.player = nil;
      }];
        
    });
    
}

//销毁时输出信息
-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


@end
