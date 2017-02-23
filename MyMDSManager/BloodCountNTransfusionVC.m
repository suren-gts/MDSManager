//
//  BloodCountNTransfusionVC.m
//  MyMDSManager
//
//  Created by CEPL on 20/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "BloodCountNTransfusionVC.h"

#import "ButtonCell.h"
#import "BloodCountHeaderCell.h"
#import "BloodCountContentDisplayCell.h"
#import "AddBloodCountVC.h"



@interface BloodCountNTransfusionVC ()

@end

@implementation BloodCountNTransfusionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnList setSelected:YES];
    [btnChart setSelected:NO];

    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   
    arrChartDropDownBloodCount = [[NSMutableArray alloc] initWithObjects:@"anc",@"ferritin",@"hgb",@"platelets",@"wbc", nil];
    [self loadDBData];
    strSelectedBlood = @"";
    
    btnBloodCounts.layer.cornerRadius = 3;
    btnBloodCounts.layer.masksToBounds = YES;
    self.arrayOfValues = [[NSMutableArray alloc] init];
    self.arrayOfDates = [[NSMutableArray alloc] init];
    
    [btnBloodCounts setTitle:@"Select Blood Counts" forState:UIControlStateNormal];
    
    [btnAddNew addTarget:self action:@selector(clickOnAddTreatment:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setTitle:@"Add Result" forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}
-(void)loadDBData
{
    arrBloodcounts=[App_Delegate.dbObj GetAllBloodCountResult];
    
    [self.view endEditing:YES];
    [tblView reloadData];
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
    
    for (int i=0;i<arrChartBloodCountData.count;i++)
    {
        NSString *keyVal = [NSString stringWithFormat:@"%d",i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        NSString *strValue = [NSString stringWithFormat:@"%@",[[arrChartBloodCountData objectAtIndex:i] valueForKey:@"value"]];
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
#pragma mark - UItableView Delegate

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
    if (arrBloodcounts.count>0)
    {
        if (indexPath.row==0)
        {
            static NSString *CellIdentifier = @"BloodCountHeaderCell";
            
            BloodCountHeaderCell *cell = (BloodCountHeaderCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"BloodCountHeaderCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            static NSString *CellIdentifier = @"BloodCountContentDisplayCell";
            
            BloodCountContentDisplayCell *cell = (BloodCountContentDisplayCell *) [tableView
                                                                               dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"BloodCountContentDisplayCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            NSMutableDictionary *dicValue=[arrBloodcounts objectAtIndex:indexPath.row-1];
            cell.lblDate.text=[dicValue valueForKey:@"date"];
            cell.lblHGB.text=[dicValue valueForKey:@"HGB"];
            cell.lblANC.text=[dicValue valueForKey:@"ANC"];
            cell.lblWBC.text=[dicValue valueForKey:@"WBC"];
            cell.lbLPLATELETS.text=[dicValue valueForKey:@"Platelets"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=arrBloodcounts.count+1 && indexPath.row>0)
    {
        UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddBloodCountVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddBloodCountVC"];
        objView.dictBloodCount=[arrBloodcounts objectAtIndex:indexPath.row-1];
        objView.editFlag=1;
        [self.navigationController pushViewController:objView animated:YES];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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
            [App_Delegate.dbObj deleteBloodCountResult:[dict valueForKey:@"rowid"]];
            
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
    AddBloodCountVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddBloodCountVC"];
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
        btnBloodCounts.hidden=YES;
        btnBloodCounts.userInteractionEnabled = NO;
        btnAddNew.hidden=NO;
        
        [self hideGraph];
    }
    else
    {
        [btnList setSelected:NO];
        [btnChart setSelected:YES];

        tblView.hidden=YES;

        btnBloodCounts.hidden=NO;
        btnBloodCounts.userInteractionEnabled = YES;
        
        if (![strSelectedBlood isEqualToString:@""])
        {
            [self LoadChartData];
        }
        
        [self showGraph];
        
        
        btnAddNew.hidden=YES;
    }
}

-(void) LoadChartData
{
    arrChartBloodCountData = [App_Delegate.dbObj getAllBloodCountForParticularBlood:strSelectedBlood];
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
        
        [self.arrayOfDates addObject:strDate];
        
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
        objPicker.EntryTag=15;
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
    strSelectedBlood = [arrChartDropDownBloodCount objectAtIndex:intIndex];
    [btnBloodCounts setTitle:strValue forState:UIControlStateNormal];
    [self LoadChartData];
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}

@end
