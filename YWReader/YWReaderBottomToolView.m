//
//  YWReaderBottomToolView.m
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import "YWReaderBottomToolView.h"

@interface YWReaderBottomToolView()

@property(nonatomic)UIButton*   catalogButton;

@end

@implementation YWReaderBottomToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    if (!_catalogButton) {
        _catalogButton = [[UIButton alloc] init];
        [self addSubview:_catalogButton];
        
        [_catalogButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_catalogButton setTitle:@"目录" forState:UIControlStateNormal];
        [_catalogButton sizeToFit];
        
        [_catalogButton addTarget:self action:@selector(pressedCatalogButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect catalogFrame = CGRectMake(15, 0, CGRectGetWidth(_catalogButton.frame), CGRectGetHeight(self.frame));
    if (!CGRectEqualToRect(catalogFrame, _catalogButton.frame)) {
        _catalogButton.frame = catalogFrame;
    }
}

- (void)pressedCatalogButton
{
    if (self.pressedCatalogBlock) {
        self.pressedCatalogBlock();
    }
}

@end
