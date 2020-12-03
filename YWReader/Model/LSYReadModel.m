//
//  LSYReadModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadModel.h"
#import "LSYReadUtilites.h"

@implementation LSYReadModel

-(instancetype)initWithePub:(NSString *)ePubPath;
{
    self = [super init];
    if (self) {
        _chapters = [LSYReadUtilites ePubFileHandle:ePubPath];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
    }
    return self;
}
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}
+(id)getLocalModelWithURL:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        if ([[key pathExtension] isEqualToString:@"epub"]){
            NSLog(@"this is epub");
            LSYReadModel *model = [[LSYReadModel alloc] initWithePub:url.path];
            model.resource = url;
            [LSYReadModel updateLocalModel:model url:url];
            return model;
        }
        else{
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        
    }
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //主线程操作
    LSYReadModel *model = [unarchive decodeObjectForKey:key];
    return model;
}
@end
