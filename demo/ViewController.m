//
//  ViewController.m
//  demo
//
//  Created by wmlab on 14/8/13.
//  Copyright (c) 2014年 wmlab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    record=0;
	// Do any additional setup after loading the view, typically from a nib.
    [self initboardnum];
    [self resetgame];
}
-(void)resetgame{
    
    size=1;
    now=0;
    time=0;
    score=0;
    [self labelreset];
    [self initUI];

}
- (void) initboardnum{
    for(int i=0;i<5;i++){
        boardsize[i]=i*i;
    }
}
- (void) initUI{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(84, 212, 600, 600)];
    btn.backgroundColor=[UIColor redColor];
    [[btn layer] setBorderWidth:2.0f];
    [[btn layer] setBorderColor:[UIColor blackColor].CGColor];
    btn.tag=1;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Arial-MT" size:500.0f];
    [btn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.shadowOffset = CGSizeMake(3.0f, 3.0f);
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:80];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startselect:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(startclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void) startselect:(id)sender{
    UIButton *btn = (UIButton *)[self.view viewWithTag:[sender tag]];
    btn.backgroundColor=[UIColor grayColor];
    
}
-(void) startclick:(id)sender{
    [self initializeTimer];
    score++;
    [self scorecount];
    UIButton *btn = (UIButton *)[self.view viewWithTag:[sender tag]];
    [self make_random];
    [self createbtn];
    [btn removeFromSuperview];
}
-(void) createbtn{
    for(int i=0;i<boardsize[size];i++){
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(84+600/size*(i%size), 212+ 600/size*(i/size), 600/size, 600/size)];
        btn.backgroundColor=[UIColor whiteColor];
        [[btn layer] setBorderWidth:2.0f];
        [[btn layer] setBorderColor:[UIColor blackColor].CGColor];
        //title
        btn.tag=i+1;
        if(i+1==a[now]){
            btn.backgroundColor=[UIColor redColor];
        }
        [btn addTarget:self action:@selector(btnselect:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
-(void) btnselect:(id)sender{
    UIButton *btn = (UIButton *)[self.view viewWithTag:[sender tag]];
    btn.backgroundColor=[UIColor grayColor];
    
}
-(void) btnclick:(id)sender{
    UIButton *btn = (UIButton *)[self.view viewWithTag:[sender tag]];
    if(a[now]==btn.tag){
        [btn removeFromSuperview];
        score++;
        [self scorecount];
        if(score==30){
            [theTimer invalidate];
            theTimer = nil;
            [self createFrame];
        }
        else{
            now++;
            if(now==boardsize[size]){
                now=0;
                [self make_random];
                [self createbtn];
            }
            else{
                UIButton *temp = (UIButton *)[self.view viewWithTag:a[now]];
                temp.backgroundColor=[UIColor redColor];
            }
        }
    }
    else{
        //中斷計時器並清空設定
        //Michael add som commit
        [theTimer invalidate];
        theTimer = nil;
        [self createFrame];
    }
}

-(void) initializeTimer {
    
    //設定Timer觸發的頻率
    float theInterval = 1.0/50.0;
    //正式啟用Timer，selector是設定Timer觸發時所要呼叫的函式
    theTimer=[NSTimer scheduledTimerWithTimeInterval:theInterval
                                     target:self
                                   selector:@selector(timecount:)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)timecount:(NSTimer *)theTimer {
    UILabel *timeLabel = (UILabel *)[self.view viewWithTag:101];
    time = time+0.02;
    timeLabel.text = [NSString stringWithFormat:@"Time:%.2f", time];
}
-(void)scorecount{
    UILabel *scoreLabel = (UILabel *)[self.view viewWithTag:100];
    scoreLabel.text = [NSString stringWithFormat:@"Score:%d", score];
}
-(void)labelreset{
    UILabel *timeLabel = (UILabel *)[self.view viewWithTag:101];
    timeLabel.text = [NSString stringWithFormat:@"Time:%.2f", time];
    UILabel *scoreLabel = (UILabel *)[self.view viewWithTag:100];
    scoreLabel.text = [NSString stringWithFormat:@"Score:%d", score];
}

- (void) make_random{
    size++;
    for(int i=0;i<boardsize[size];i++){
        a[i]=i+1;
        random[i]=arc4random();
    }
    for(int i=0;i<boardsize[size];i++){
        for(int j=i+1;j<boardsize[size];j++){
            if(random[i]<random[j]){
                int temp=random[i];
                random[i]=random[j];
                random[j]=temp;
                temp=a[i];
                a[i]=a[j];
                a[j]=temp;
            }
        }
    }
}

-(void)createFrame{
    UIButton *myView=[UIButton buttonWithType:UIButtonTypeCustom];
    myView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0.7 alpha:0.5];
    myView.frame = CGRectMake(0, 0, 768, 1024);
    myView.tag=1000;
    [self.view addSubview:myView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
    button.tag=1002;
    [button addTarget:self
               action:@selector(removepop)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:26.0];
    if(score==30){
        if(time<record||record==0){
            record=time;
            [button setTitle:[NSString stringWithFormat:@"New Record!!!!\n%.2f\n \\0/ \\0/ \\0/ \\0/\n \\0/ \\0/ \\0/ \nReset Game",record] forState:UIControlStateNormal];
        }
        else{
            [button setTitle:[NSString stringWithFormat:@"You Win!!!!\n%.2f\n \\0/ \\0/ \\0/\nBut Still Weak...\n AllTimeRecord:%.2f\n Reset Game",time,record
            ]forState:UIControlStateNormal];
        }
    }
    else{
        [button setTitle:@"Loser!!!!\nSo Weak.....\n:p :P :p :P\nReset Game" forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(234, 362, 300.0, 300);
    button.backgroundColor=[UIColor colorWithRed: 0.7 green:0 blue:0 alpha:0.8];
    [self.view addSubview:button];
}

-(void)removepop{
    for(int i=0;i<boardsize[size];i++){
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        [btn removeFromSuperview];
    }
    
    [self resetgame];
    
    UIButton *buttonClicked = (UIButton *)[self.view viewWithTag:1000];
    UIButton *viewClicked = (UIButton *)[self.view viewWithTag:1002];
    [buttonClicked removeFromSuperview];
    [viewClicked removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
