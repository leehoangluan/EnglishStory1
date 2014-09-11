//
//  Story.h
//  EnglishStoryPro
//
//  Created by Lê Đình Tuấn on 9/2/14.
//  Copyright (c) 2014 ChauApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (assign) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@end
