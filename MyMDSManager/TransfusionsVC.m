//
//  TransfusionsVC.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "TransfusionsVC.h"

#import "ButtonCell.h"
#import "ThreeLableHeaderCell.h"
#import "ThreeLableContentCell.h"
#import "AddTransfusionsVC.h"


@interface TransfusionsVC ()

@end

@implementation TransfusionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnList setSelected:YES];
    [btnChart setSelected:NO];
    
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    arrChartDropDownBloodCount = [[NSMutableArray alloc] initWithObjects:@"PLATELETS",@"PRBCs", nil];
    
    strSelectBlood = @"";
    
    btnBloodCounts.layer.cornerRadius = 3;
    btnBloodCounts.layer.masksToBounds = YES;
    self.arrayOfValues = [[NSMutableArray alloc] init];
    self.arrayOfDates = [[NSMutableArray alloc] init];
    
    [btnBloodCounts setTitle:@"Select Transfusion" forState:UIControlStateNormal];
    
    [btnAddTransfusion addTarget:self action:@selector(clickOnAddTreatment:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddTransfusion setTitle:@"Add Result" forState:UIControlStateNormal];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark - Graph

-(void)showGraph
{
    [lineGraph removeFromSuperview];
    
    for (UIView *view in [self.view subviews])
    {
        if ([view isKindOfClass:[SHLineGraphView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    
    lineGraph = [[SHLineGraphView alloc] init];
    
    CGFloat Y = btnBloodCounts.frame.origin.y+btnBloodCounts.frame.size.height+30;
    
    lineGraph.frame =CGRectMake( 20, Y  ,  self.view.frame.size.width-40, 250) ;
    
    lineGraph.tag = 999;
    
    lineGraph.backgroundColor = [UIColor clearColor];
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor blackColor],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:8],
                                       kYAxisLabelColorKey : [UIColor blackColor],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:8],
                                       kYAxisLabelSideMarginsKey : @4,
                                       kPlotBackgroundLineColorKey : [UIColor lightGrayColor],
                                       kDotSizeKey : @5
                                       };
    
    lineGraph.themeAttributes = _themeAttributes;
    
    int maxValue = 0;
    
    NSMutableArray *arrAxis = [[NSMutableArray alloc] init];
    for (int i=0;i<self.arrayOfDates.count;i++)
    {
        NSString *keyVal = [NSString stringWithFormat:@"%d",i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *strValue = [NSString stringWithFormat:@"%@",[self.arrayOfDates objectAtIndex:i] ];
        [dict setValue:strValue forKey:keyVal];
        [arrAxis addObject:dict];
    }
    
    lineGraph.xAxisValues = arrAxis;
    
    NSMutableArray *plottingValue = [[NSMutableArray alloc]init];
    NSMutableArray *plottingLabelValue = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.arrayOfValues.count;i++)
    {
        NSString *keyVal = [NSString stringWithFormat:@"%d",i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *strValue = [NSString stringWithFormat:@"%@",[self.arrayOfValues objectAtIndex:i] ];
        [dict setValue:strValue forKey:keyVal];
        
        if (maxValue < [strValue intValue])
        {
            maxValue = [strValue intValue];
        }
        
        [plottingLabelValue addObject:[NSString stringWithFormat:@"%@,%@",strValue,self.arrayOfDates[i]]];
        [plottingValue addObject:dict];
    }
    
    
    
    NSNumber * max = [[NSNumber alloc] initWithInt:maxValue+50];
    
    lineGraph.yAxisRange = max;
    lineGraph.yAxisSuffix = @"";
    
    SHPlot *_plot = [[SHPlot alloc] init];
    
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:250/255.f green:224/255.f blue:230/255.f alpha:0.75],
                                           kPlotStrokeWidthKey :@2,
                                           kPlotStrokeColorKey :[UIColor colorWithRed:132/255.f green:53/255.f blue:34/255.f alpha:1],
                                           kPlotPointFillColorKey :[UIColor colorWithRed:132/255.f green:53/255.f blue:34/255.f alpha:1],
                                           kPlotPointValueFontKey :[UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    _plot.plottingValues = plottingValue;
    _plot.plottingPointsLabels = plottingLabelValue;
    _plot.plotThemeAttributes = _plotThemeAttributes;
    [lineGraph addPlot:_plot];
    [lineGraph setupTheView];
    
    [self.view addSubview:lineGraph];
    
}

-(void)hideGraph
{
    [lineGraph removeFromSuperview];
    
}


#pragma mark -
#pragma mark - Load Data

-(void)loadDBData
{
    arrBloodcounts=[App_Delegate.dbObj GetAllTransfusion];
    [self.view endEditing:YES];
    [tblView reloadData];
}
-(void)loadLastBloodCount
{
    
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (arrBloodcounts.count>0)
    {
        return arrBloodcounts.count+1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0)
    {
        return 30;
    }
    else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        static NSString *CellIdentifier = @"ThreeLableHeaderCell";
        
        ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView
                                                               dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableHeaderCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.lblHeading1.text = @"Date";
        cell.lblHeading2.text = @"Type";
        cell.lblHeading3.text = @"Unit";
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"ThreeLableContentCell";
        
        ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        NSMutableDictionary *dicValue=[arrBloodcounts objectAtIndex:indexPath.row-1];
        cell.lblTitle1.text=[dicValue valueForKey:@"date"];
        cell.lblTitle2.text=[dicValue valueForKey:@"type"];
        cell.lblTitle3.text=[dicValue valueForKey:@"unit"];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=arrBloodcounts.count+1 && indexPath.row>0)
    {
        UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddTransfusionsVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddTransfusionsVC"];
        objView.dictLocalValue=[arrBloodcounts objectAtIndex:indexPath.row-1];
        objView.editFlag=1;
        [self.navigationController pushViewController:objView animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.row>0 && indexPath.row !=arrBloodcounts.count+1)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row>0 && indexPath.row !=arrBloodcounts.count+1)
        {
            NSMutableDictionary *dict = [arrBloodcounts objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteTransfusion:[dict valueForKey:@"rowid"]];
            
            [App_Delegate CheckBeforeUploadMainDB];
            
            [self performSelector:@selector(loadDBData) withObject:nil afterDelay:0.5];
        }
    }
}


#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnAddTreatment:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddTransfusionsVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddTransfusionsVC"];
    
    [self.navigationController pushViewController:objView animated:YES];
}

-(IBAction)clickOnTabButtons:(UIButton *)sender
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        
                    } completion:NULL];
    
    if (sender.tag==0)
    {
        [btnList setSelected:YES];
        [btnChart setSelected:NO];
        tblView.hidden=NO;
        [tblView reloadData];
        [self hideGraph];
        btnBloodCounts.hidden=YES;
        btnBloodCounts.userInteractionEnabled = NO;
        btnAddTransfusion.hidden=NO;
    }
    else
    {
        [btnList setSelected:NO];
        [btnChart setSelected:YES];
        
        tblView.hidden=YES;
        
        btnBloodCounts.hidden=NO;
        btnBloodCounts.userInteractionEnabled = YES;
        btnAddTransfusion.hidden=YES;
        if (![strSelectBlood isEqualToString:@""])
        {
            [self loadChartData];
        }
        [self showGraph];
    }
}

-(void)loadChartData
{
    arrChartBloodCountData = [App_Delegate.dbObj getAllTransusionForParticularBlood:strSelectBlood];
    NSInteger SizeAdjust=1;
    if (arrChartBloodCountData.count>5)
    {
        SizeAdjust=arrChartBloodCountData.count/5;
    }
    
    
    [self refresh:nil];
}

- (IBAction)refresh:(id)sender
{
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    
    for (int i = 0; i < arrChartBloodCountData.count; i++)
    {
        NSMutableDictionary *dicValue = [arrChartBloodCountData objectAtIndex:i];
        if (!self.arrayOfDates)
        {
            self.arrayOfDates=[[NSMutableArray alloc] init];
        }
        
        NSString *strDate = [self changeDateFormat:[dicValue valueForKey:@"date"] withFormat:@"MMM dd, yyyy" changeFormat:@"MM-dd-yy"];
        
        
        if (strDate)
        {
            [self.arrayOfDates addObject:strDate];
        }
      
        
        if (!self.arrayOfValues)
        {
            self.arrayOfValues=[[NSMutableArray alloc] init];
        }
        [self.arrayOfValues addObject:[dicValue valueForKey:@"value"]];
        
    }
    
    [self showGraph];
    
    
    
}


-(NSString *)changeDateFormat:(NSString *)strDate withFormat:(NSString *)currentFormat changeFormat:(NSString *)requiredFormat
{
    NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
    [currentFormatter setDateFormat:currentFormat];
    
    NSDate *date = [currentFormatter dateFromString:strDate];
    
    NSDateFormatter *requiredFormatter = [[NSDateFormatter alloc] init];
    [requiredFormatter setDateFormat:requiredFormat];
    
    NSString *changedDate = [requiredFormatter stringFromDate:date];
    
    return changedDate;
    
}


#pragma mark Action Sheet Methods


-(IBAction)clickOnBloodDropDown:(id)sender
{
    if (!isActionSheetVisible && arrChartDropDownBloodCount.count>0)
    {
        isActionSheetVisible = YES;
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.EntryTag=16;
        objPicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             objPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:objPicker.view];
    }
}

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    isActionSheetVisible=NO;
    strSelectBlood = [arrChartDropDownBloodCount objectAtIndex:intIndex];
    [btnBloodCounts setTitle:strSelectBlood forState:UIControlStateNormal];
    [self loadChartData];
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}

@end
