//
//  StoriesTableViewController.m
//  EnglishStoryPro
//
//  Created by Lê Đình Tuấn on 9/2/14.
//  Copyright (c) 2014 ChauApple. All rights reserved.
//

#import "StoriesTableViewController.h"

@interface StoriesTableViewController ()
{
    NSMutableArray *arrayOfStory;
    sqlite3 *storyDB;
    NSString *dbPathString;
}
@end

@implementation StoriesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayOfStory = [[NSMutableArray alloc]init];
    [self createOrOpenDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Show Data
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //getdata
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String], &storyDB) == SQLITE_OK) {
        [arrayOfStory removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM english_listen"];
        const char *query_sql = [querySQL UTF8String];
        if (sqlite3_prepare(storyDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *strID = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *title = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *content = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                Story *story = [[Story alloc]init];
                
                [story setId:[strID intValue]];
                [story setTitle:title];
                [story setContent:content];
                
                [arrayOfStory addObject:story];
            }
        }
    }
    
    
    [self.tableView reloadData];
}

#pragma Create or Open Database
- (void)createOrOpenDB{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"english.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:dbPathString]){
        const char *dbPath = [dbPathString UTF8String];
        
        //create db in here
        if (sqlite3_open(dbPath, &storyDB) == SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS english_listen (id INTEGER PRIMARY KEY AUTOINCREMENT, lesson INT, title TEXT, content TEXT)";
            sqlite3_exec(storyDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(storyDB);
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOfStory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //UIImage *imageList = [UIImage imageNamed:@"storyIcon.png"];
    //cell.imageView.image = imageList;
    Story *aStory = [arrayOfStory objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"Story " stringByAppendingString:[NSString stringWithFormat:@"%d", aStory.id]];
    cell.detailTextLabel.text = aStory.title;
    
    return cell;
}

#pragma View Detail
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ViewStory"]) {
        Story *selectedStory = [arrayOfStory objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        StoryViewController *destViewControl = segue.destinationViewController;
        destViewControl.storyView = selectedStory;
        
    }
}

@end
