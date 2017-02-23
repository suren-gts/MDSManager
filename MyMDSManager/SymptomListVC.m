//
//  SymptomListVC.m
//  MyMDSManager
//
//  Created by CEPL on 28/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "SymptomListVC.h"
#import "ThreeLableContentCell.h"
#import "ThreeLableHeaderCell.h"
#import "SymptomObject.h"
#import "SymptomTrackerVC.h"


@interface SymptomListVC ()

@end

@implementation SymptomListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnList setSelected:YES];
    [btnChart setSelected:NO];

    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self loadDBData];
    [self loadLastSymptom];
    
    btnSymtomDropDownList.layer.cornerRadius = 3;
    btnSymtomDropDownList.layer.masksToBounds = YES;
    self.arrayOfValues = [[NSMutableArray alloc] init];
    self.arrayOfDates = [[NSMutableArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
    [self loadLastSymptom];
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
    
    CGFloat Y = btnSymtomDropDownList.frame.origin.y+btnSymtomDropDownList.frame.size.height+30;
    
    lineGraph.frame =CGRectMake( 20, Y  ,  self.view.frame.size.width-40, 250) ;
    
    lineGraph.tag = 999;
    
    lineGraph.backgroundColor = [UIColor clearColor];
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor blackColor],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:8],
                                       kYAxisLabelColorKey : [UIColor blackColor],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:8],
                                       kYAxisLabelSideMarginsKey : @ 5,
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
    
    NSNumber * max = [[NSNumber alloc] initWithInt:10];
    
    
    lineGraph.yAxisRange = max;
    lineGraph.yAxisSuffix = @"";
    
    lineGraph.isStartSFromZero=YES;
    
    
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
    arrSympotms=[App_Delegate.dbObj getAllSymptomInfoList];
    
    [self.view endEditing:YES];
    [tblView reloadData];
}

-(void)loadLastSymptom
{
    arrChartDropDownsymptom = [App_Delegate.dbObj getAllUniqueSymptomForChart];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"LastAddedSymptom"])
    {
        NSString *strLastAdded = [[NSUserDefaults standardUserDefaults]valueForKey:@"LastAddedSymptom"];
        arrChartSymptom = [App_Delegate.dbObj getAllSymptomForParticularSymptom:strLastAdded];
      
        if (arrChartDropDownsymptom>0)
        {
            [btnSymtomDropDownList setTitle:strLastAdded forState:UIControlStateNormal];
        }
        else
        {
            [btnSymtomDropDownList setTitle:@"No Symptom" forState:UIControlStateNormal];
        }
    }
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (arrSympotms.count>0)
    {
        return arrSympotms.count+1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrSympotms.count>0)
    {
        if (indexPath.row==0)
        {
            return 30;
        }
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
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
        cell.lblHeading1.text=@"Date";
        cell.lblHeading2.text=@"Symptom";
        cell.lblHeading3.text=@"Severity";
        
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
        SymptomObject *object=[arrSympotms objectAtIndex:indexPath.row-1];
       
        cell.lblTitle1.text=object.strDate;
        cell.lblTitle2.text=object.strSymptomSubCat;
        cell.lblTitle3.text=object.strServirty;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
    {
        UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SymptomTrackerVC *objSymptom=[objStoryboard instantiateViewControllerWithIdentifier:@"SymptomTrackerVC"];
        objSymptom.objLocalSymptom=[arrSympotms objectAtIndex:indexPath.row-1];
        objSymptom.strEntrValue=@"edit";
        [self.navigationController pushViewController:objSymptom animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
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
        if (indexPath.row>0)
        {
            SymptomObject *objSymtom = [arrSympotms objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteSymptom:objSymtom.strId];
            
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
        btnAddSymptom.hidden = NO;
        [tblView reloadData];
     
        btnSymtomDropDownList.hidden=YES;
        btnSymtomDropDownList.userInteractionEnabled = NO;
        
        [self hideGraph];
    }
    else
    {
        [btnList setSelected:NO];
        [btnChart setSelected:YES];
   
        tblView.hidden=YES;
        btnAddSymptom.hidden =YES;
        
        [self refresh:nil];
        
        [self showGraph];
        
        btnSymtomDropDownList.hidden=NO;
        btnSymtomDropDownList.userInteractionEnabled = YES;
        
       
    }
   
}

- (IBAction)refresh:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSInteger tag=1;
    if (btn)
    {
        tag=btn.tag;
    }
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];

   
    for (int i = 0; i < arrChartSymptom.count; i++)
    {
        SymptomObject *object=[arrChartSymptom objectAtIndex:i];
        if (!self.arrayOfDates)
        {
            self.arrayOfDates=[[NSMutableArray alloc] init];
        }
        
        NSString *strDate = [self changeDateFormat:object.strDate withFormat:@"MMM dd, yyyy" changeFormat:@"MM-dd-yy"];
        
        [self.arrayOfDates addObject:strDate];
        
        if (!self.arrayOfValues)
        {
            self.arrayOfValues=[[NSMutableArray alloc] init];
        }
        [self.arrayOfValues addObject:object.strServirty];
        
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

#pragma mark - 
#pragma mark - Action Sheet Methods


-(IBAction)clickOnSymptomDropDown:(id)sender
{
    if (!isActionSheetVisible && arrChartDropDownsymptom.count>0)
    {
        isActionSheetVisible = YES;
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.EntryTag=12;
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
    arrChartSymptom = [App_Delegate.dbObj getAllSymptomForParticularSymptom:strValue];
    [btnSymtomDropDownList setTitle:strValue forState:UIControlStateNormal];
    [self refresh:nil];
    
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}


@end
