//
//  commentsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/10/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "commentsController.h"
#import "News.h"
#import "NewsComment.h"
#import "CommentCell.h"

#define CELL_ID @"CommentCell"

@interface commentsController ()
@property(nonatomic,strong) NSMutableArray * CommentsList;
@end

@implementation commentsController
@synthesize CommentsTable, CommentsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CommentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsComment * commentForCell = CommentsList[indexPath.row];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 128)];
    [v setBackgroundColor:[UIColor colorWithRed:1.03 green:0.32 blue:0.08 alpha:1]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];

    [cell.Date setText:[format stringFromDate:commentForCell.Date]];
    [cell.Author setText:commentForCell.Pseudonym];
    [cell.Details setText:commentForCell.Comments];
    [cell setSelectedBackgroundView:v];
    
    v = nil;
    format = nil;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
