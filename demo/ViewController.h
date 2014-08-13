//
//  ViewController.h
//  demo
//
//  Created by wmlab on 14/8/13.
//  Copyright (c) 2014年 wmlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    int random[25];
    int a[25];
    int boardsize[6];
    int now;
    int size;
    int score;
    float time;
    float record;
    NSTimer *theTimer;
}
@end
