//
//  YWReaderChapterView.h
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWReaderChapterView : UIView

@property(nonatomic,copy)void(^didSelectRowBlock)(NSIndexPath *indexPath);

- (void)reloadData:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
