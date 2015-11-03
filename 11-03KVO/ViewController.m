//
//  ViewController.m
//  11-03KVO
//
//  Created by 伏董 on 15/11/3.
//  Copyright © 2015年 伏董. All rights reserved.
//

/*
    监听观察者模式KVO ，监听到数据改变可以及时更新数据
 */

#import "ViewController.h"
#import "Worker.h"
@interface ViewController (){

    UILabel *showInfoLabel;
    UIButton *changeButton;
    Worker *worker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    worker = [[Worker alloc] init];
    worker.name = @"xiaoli";
    worker.age = @"18";
    

    showInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 50)];
    showInfoLabel.backgroundColor = [UIColor redColor];
    showInfoLabel.textColor = [UIColor whiteColor];
    showInfoLabel.textAlignment = NSTextAlignmentCenter;
    showInfoLabel.text = [NSString stringWithFormat:@"%@ -- %@",worker.name,worker.age];
    [self.view addSubview:showInfoLabel];
    
    changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    changeButton.frame = CGRectMake(50, 100, 220, 40);
    changeButton.backgroundColor = [UIColor blackColor];
    [changeButton setTitle:@"增加五岁" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    
    //注册观察者 谁的信息发生变化谁来注册观察者
    /*
        第一个参数：观察者是谁 一般为self
        第二个参数：被改变的key值
        第三个参数：监听改变的新值还是旧值
        第四个参数：携带的内容
        一定要实现observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context这个方法
     */
    [worker addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    
}

//监听到值发生变化的时候处理改变事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
       //判断keypath是否是监听的值，判断object是否是发送的值
    if ([keyPath isEqualToString:@"age"] && object == worker) {
    
        showInfoLabel.text = [NSString stringWithFormat:@"%@ --- %@",worker.name,worker.age];
    }
    NSString *newAge = change[@"new"];
    NSString *oldAge = change[@"old"];
    NSLog(@"new:%@  old:%@",newAge,oldAge);
    
}

//移除监听

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"key"];

}

- (void)buttonClicked:(UIButton *) button{
    //改变员工的年龄
    NSInteger age = [worker.age integerValue];
    age += 5;
    worker.age = [NSString stringWithFormat:@"%ld",age];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
