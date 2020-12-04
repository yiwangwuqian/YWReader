//
//  YWReaderViewController.h
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import <YWHTMLKit/YWHTMLKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LSYReadModel;
@interface YWReaderViewController : YWHTMLViewController

@property(nonatomic)LSYReadModel* model;

@end

NS_ASSUME_NONNULL_END
