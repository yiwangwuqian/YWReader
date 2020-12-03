//
//  YWMainViewController.m
//  YWReader
//
//  Created by guohaoyang on 2020/12/3.
//

#import "YWMainViewController.h"
#import "LSYReadModel.h"
#import <YWHTMLKit/YWHTMLViewController.h>

@interface YWMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView*                tableView;
@property(nonatomic)NSMutableArray*             dataArray;
@property(nonatomic)UIActivityIndicatorView*    epubActivity;
@end

@implementation YWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    if (!_epubActivity) {
        _epubActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_epubActivity];
        _epubActivity.hidden = YES;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _epubActivity.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadDataArray];
}

- (void)reloadDataArray
{
    [_dataArray removeAllObjects];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (items.count > 0) {
        for (NSString *name in items) {
            if ([name hasSuffix:@".epub"]) {
                [_dataArray addObject:name];
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ResueCellID = @"ResueCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResueCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ResueCellID];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    NSString *item = _dataArray[indexPath.row];
    cell.textLabel.text = item;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_epubActivity startAnimating];

    NSString *item = _dataArray[indexPath.row];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:item];
    NSURL *fileURL = [NSURL fileURLWithPath:path];;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        LSYReadModel *model = [LSYReadModel getLocalModelWithURL:fileURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_epubActivity stopAnimating];
            YWHTMLViewController *controller = [[YWHTMLViewController alloc] initWithURLString:model.chapters[1].fullpath];
            [self presentViewController:controller animated:YES completion:NULL];
        });
    });
}

@end
