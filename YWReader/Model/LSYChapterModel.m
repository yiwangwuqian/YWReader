//
//  LSYChapterModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#define kDocuments NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#import "LSYChapterModel.h"

@interface LSYChapterModel ()
@property (nonatomic,strong) NSMutableArray *pageArray;
@end

@implementation LSYChapterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}

+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title
{
    LSYChapterModel *model = [[LSYChapterModel alloc] init];

    model.title = title;
    model.chapterpath = chapterpath;
    return model;
}

- (NSString *)fullpath
{
    return [@"file://" stringByAppendingPathComponent:[kDocuments stringByAppendingPathComponent:self.chapterpath]];
}

-(id)copyWithZone:(NSZone *)zone
{
    LSYChapterModel *model = [[LSYChapterModel allocWithZone:zone] init];
    model.title = self.title;
    model.pageArray = self.pageArray;
    return model;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
    [aCoder encodeObject:self.chapterpath forKey:@"chapterpath"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
        self.chapterpath = [aDecoder decodeObjectForKey:@"chapterpath"];
    }
    return self;
}
@end
