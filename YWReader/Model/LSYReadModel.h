//
//  LSYReadModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYChapterModel.h"
@interface LSYReadModel : NSObject<NSCoding>
@property (nonatomic,strong) NSURL *resource;
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;

-(instancetype)initWithePub:(NSString *)ePubPath;
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url;
+(id)getLocalModelWithURL:(NSURL *)url;
@end
