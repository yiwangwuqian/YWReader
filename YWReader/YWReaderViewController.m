//
//  YWReaderViewController.m
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import "YWReaderViewController.h"
#import "YWReaderChapterView.h"
#import "YWReaderBottomToolView.h"
#import "LSYReadModel.h"

@interface YWReaderViewController ()

@property(nonatomic)UIButton*                   backButton;
@property(nonatomic)YWReaderChapterView*        chapterView;
@property(nonatomic)YWReaderBottomToolView*     toolView;

@end

@implementation YWReaderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self toolView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isBeingPresented) {
        if (![self.view.subviews containsObject:self.backButton]) {
            [self.view addSubview:self.backButton];
        }
    }
}

- (UIButton *)backButton
{
    if (!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"common_navigation_back"];
        [backButton setImage:image forState:UIControlStateNormal];
        
        [backButton sizeToFit];
        [backButton addTarget:self
                       action:@selector(didClickBackButton:)
             forControlEvents:UIControlEventTouchUpInside];
        _backButton = backButton;
    }
    
    return _backButton;
}

- (YWReaderChapterView *)chapterView
{
    if (!_chapterView) {
        _chapterView = [[YWReaderChapterView alloc] initWithFrame:self.contentView.frame];
        [self.view addSubview:_chapterView];
        
        __weak __typeof(self) weakSelf = self;
        [_chapterView setDidSelectRowBlock:^(NSIndexPath * _Nonnull indexPath) {
            weakSelf.chapterView.hidden = YES;
            
            NSInteger index = indexPath.row;
            [weakSelf loadURL:[weakSelf.model.chapters objectAtIndex:index].fullpath];
        }];
    }
    return _chapterView;
}

- (YWReaderBottomToolView *)toolView
{
    if (!_toolView) {
        CGFloat toolViewHeight = 44;
        _toolView = [[YWReaderBottomToolView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.view.frame) - toolViewHeight,
                                                                             CGRectGetWidth(self.view.frame),
                                                                             toolViewHeight)];
        [self.view addSubview:_toolView];
        
        __weak __typeof(self) weakSelf = self;
        [_toolView setPressedCatalogBlock:^{
            [weakSelf showChapterView];
        }];
    }
    return _toolView;
}

- (void)didClickBackButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat backButtonTop = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat backButtonHeight = CGRectGetHeight(_backButton.frame);
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = UIApplication.sharedApplication.keyWindow.safeAreaInsets;
        backButtonHeight = insets.top;
    }
    CGRect backButtonFrame = CGRectMake(15, backButtonTop, CGRectGetWidth(_backButton.frame), backButtonHeight);
    if (!CGRectEqualToRect(backButtonFrame, _backButton.frame)) {
        _backButton.frame = backButtonFrame;
    }
    
    CGFloat toolViewOriginY = CGRectGetMaxY(self.contentView.frame) - CGRectGetHeight(self.toolView.frame);
    if (CGRectGetMinY(self.toolView.frame) != toolViewOriginY) {
        CGRect toolViewFrame = self.toolView.frame;
        toolViewFrame.origin.y = toolViewOriginY;
        self.toolView.frame = toolViewFrame;
        [self.view bringSubviewToFront:self.toolView];
    }
}

- (void)showChapterView
{
    if (self.chapterView.hidden) {
        self.chapterView.hidden = NO;
    } else {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        if (self.model.chapters.count) {
            for (NSInteger i=0; i<self.model.chapters.count; i++) {
                LSYChapterModel *chapter = self.model.chapters[i];
                NSString *title = chapter.title;
                if (title == NULL) {
                    title = [NSString stringWithFormat:@"%ld 暂无",i];
                }
                [items addObject:title];
            }
        }
        [self.chapterView reloadData:items];
    }
}

@end
