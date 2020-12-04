//
//  YWReaderBottomToolView.h
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWReaderBottomToolView : UIView

@property(nonatomic,copy)void(^pressedCatalogBlock)(void);

@end

NS_ASSUME_NONNULL_END
