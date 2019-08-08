//
//  BMGooglePlaces.h
//  NavigationApp
//
//  Created by Srishti Innovative on 15/10/15.
//  Copyright (c) 2015 Srishti Innovative. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GooglePlacesDelegate <NSObject>
//-(void)selectedPlace:(NSString *)place;
@optional
-(void)selectedPlace:(NSObject *)place;
-(void)selectedCollege:(NSString *)collegeName;
@end

@interface BMGooglePlaces : UIView <UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableViewObj;
}

@property (nonatomic,strong)NSMutableArray *arrayToLoad;
@property BOOL isGooglePlacesData;
@property (nonatomic,retain) id <GooglePlacesDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)reloadPlaces:(NSArray*)arrayPlaces;
-(void)hideMenu;

@end
