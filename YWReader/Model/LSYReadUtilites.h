//
//  LSYReadUtilites.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSYReadUtilites : NSObject
/**
 * ePub格式处理
 * 返回章节信息数组
 */
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
@end
