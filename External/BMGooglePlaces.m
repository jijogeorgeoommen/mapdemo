//
//  BMGooglePlaces.m
//  NavigationApp
//
//  Created by Srishti Innovative on 15/10/15.
//  Copyright (c) 2015 Srishti Innovative. All rights reserved.
//

#import "BMGooglePlaces.h"
#import "SPGooglePlacesAutocompletePlace.h"

@implementation BMGooglePlaces

-(instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        tableViewObj = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0) style:UITableViewStylePlain];
        tableViewObj.delegate = self;
        tableViewObj.dataSource = self;
        tableViewObj.backgroundColor = [UIColor whiteColor];
        tableViewObj.showsVerticalScrollIndicator = NO;
        tableViewObj.layer.borderColor = [[UIColor colorWithRed:14/255.0 green:87/255.0 blue:83/255.0 alpha:1.0] CGColor];
        tableViewObj.layer.borderWidth = 1.0;
        if (self.isGooglePlacesData) {
            tableViewObj.layer.cornerRadius = 10.0;
        }
        [self addSubview:tableViewObj];
        
        [UIView animateWithDuration:0.5 animations:^{
            tableViewObj.frame = CGRectMake(CGRectGetMinX(tableViewObj.frame),CGRectGetMinY(tableViewObj.frame),CGRectGetWidth(tableViewObj.frame), 176);
        }];
    }
    return self;
}

#pragma mark - Reload Page
-(void)reloadPlaces:(NSArray*)arrayPlaces{
    [self.arrayToLoad removeAllObjects];
    [self.arrayToLoad addObjectsFromArray:arrayPlaces];
    [tableViewObj reloadData];
    
}

-(void)hideMenu{
    [UIView animateWithDuration:0.5 animations:^{
        tableViewObj.frame = CGRectMake(CGRectGetMinX(tableViewObj.frame),CGRectGetMinY(tableViewObj.frame),CGRectGetWidth(tableViewObj.frame), 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayToLoad.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if (self.isGooglePlacesData) {
        SPGooglePlacesAutocompletePlace *place = (SPGooglePlacesAutocompletePlace *)self.arrayToLoad[indexPath.row];
        cell.textLabel.text = place.name;
    }
    else{
      
        if ([self.arrayToLoad[indexPath.row] isKindOfClass:[SPGooglePlacesAutocompletePlace class]]) {
             SPGooglePlacesAutocompletePlace *place = self.arrayToLoad[indexPath.row];
             cell.textLabel.text = place.name;
        }
        else
        {
        
            cell.textLabel.text = self.arrayToLoad[indexPath.row];
        }
       
    }
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.5 animations:^{
        tableViewObj.frame = CGRectMake(CGRectGetMinX(tableViewObj.frame),CGRectGetMinY(tableViewObj.frame),CGRectGetWidth(tableViewObj.frame), 0);
    } completion:^(BOOL finished) {
        if (self.isGooglePlacesData) {
            SPGooglePlacesAutocompletePlace *place = (SPGooglePlacesAutocompletePlace *)self.arrayToLoad[indexPath.row];
             [self.delegate selectedPlace:place];
        }else{
            [self.delegate selectedCollege:self.arrayToLoad[indexPath.row]];
        }
        [self removeFromSuperview];
    }];
}

@end
