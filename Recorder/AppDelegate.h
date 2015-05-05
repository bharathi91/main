//
//  AppDelegate.h
//  Recorder
//
//  Created by CompIndia on 22/04/15.
//  Copyright (c) 2015 own. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSMutableDictionary *settings;
@property (strong, nonatomic) NSFileManager *filemanager;
@property (strong, nonatomic)NSArray *searchPaths;

@property (strong, nonatomic)NSString *documentPath,*filepath;


@end

