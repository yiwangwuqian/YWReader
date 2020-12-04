//
//  YWReaderChapterView.m
//  YWReader
//
//  Created by guohaoyang on 2020/12/4.
//

#import "YWReaderChapterView.h"

@interface YWReaderChapterView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView*                tableView;
@property(nonatomic)NSMutableArray*             dataArray;
@end

@implementation YWReaderChapterView

- (void)reloadData:(NSArray *)items
{
    [self.dataArray removeAllObjects];
    
    if (items.count) {
        [self.dataArray addObjectsFromArray:items];
    }
    
    [_tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    self.backgroundColor = [UIColor whiteColor];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(indexPath);
    }
}

@end
