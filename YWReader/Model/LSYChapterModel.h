//
//  LSYChapterModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSYChapterModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSString*      title;
@property (nonatomic,copy) NSString*        chapterpath;
@property (nonatomic,readonly) NSString*    fullpath;
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title;
@end

