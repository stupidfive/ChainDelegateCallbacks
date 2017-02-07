//
//  ViewController.m
//  ChainDelegateCallbacks
//
//  Created by George Wu on 03/02/2017.
//  Copyright © 2017 George Wu. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self request1];
        RACDisposable *d =
        [[self rac_signalForSelector:@selector(delegateCallback1:)]
         subscribeNext:^(RACTuple *  _Nullable x) {
             NSLog(@"Callback 1 triggered: %@", x);
             BOOL success = [x.first boolValue];
             if (success) {
                 [subscriber sendNext:nil];
                 [subscriber sendCompleted];
             } else {
                 [subscriber sendError:nil];
             }
         }];
        return [RACDisposable disposableWithBlock:^{
            [d dispose];
        }];
    }]
     flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
         return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
             [self request2];
             RACDisposable *d =
             [[self rac_signalForSelector:@selector(delegateCallback2:)]
              subscribeNext:^(RACTuple *  _Nullable x) {
                  NSLog(@"Callback 2 triggered: %@", x);
                  BOOL success = [x.first boolValue];
                  if (success) {
                      [subscriber sendNext:nil];
                      [subscriber sendCompleted];
                  } else {
                      [subscriber sendError:nil];
                  }
              }];
             return [RACDisposable disposableWithBlock:^{
                 [d dispose];
             }];
         }];
     }]
      flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
         return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
             [self request3];
             RACDisposable *d =
             [[self rac_signalForSelector:@selector(delegateCallback3:)]
              subscribeNext:^(RACTuple *  _Nullable x) {
                  NSLog(@"Callback 3 triggered: %@", x);
                  BOOL success = [x.first boolValue];
                  if (success) {
                      [subscriber sendNext:nil];
                      [subscriber sendCompleted];
                  } else {
                      [subscriber sendError:nil];
                  }
              }];
             return [RACDisposable disposableWithBlock:^{
                 [d dispose];
             }];
         }];
     }]
     subscribeNext:^(id  _Nullable x) {
         NSLog(@"Final next");
     } error:^(NSError * _Nullable error) {
         NSLog(@"Final error");
     } completed:^{
         NSLog(@"Final complete");
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // simulate other delegate callback triggers
    [self delegateCallback1:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // similate other delegate callback triggers
    [self delegateCallback2:YES];
}

- (void)request1 {
    NSLog(@"%s", __func__);
    
    // simulate async callback
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delegateCallback1:YES];
    });
}

- (void)request2 {
    NSLog(@"%s", __func__);
    
    // simulate async callback
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delegateCallback2:YES];
    });
}

- (void)request3 {
    NSLog(@"%s", __func__);
    
    // simulate async callback
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delegateCallback3:YES];
    });
}

- (void)delegateCallback1:(BOOL)success {
    NSLog(@"%s", __func__);
}

- (void)delegateCallback2:(BOOL)success {
    NSLog(@"%s", __func__);
}

- (void)delegateCallback3:(BOOL)success {
    NSLog(@"%s", __func__);
}

@end
