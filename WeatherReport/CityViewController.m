//
//  CityViewController.m
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "CityViewController.h"
#import "WeatherInfo.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherCollectionReusableView.h"
#import "Settings.h"


@interface CityViewController ()
{
    NSString* unitStr;
    UIActivityIndicatorView* activityIndicator;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray* collectionData;

@end

@implementation CityViewController

static NSString* iconAddress = @"http://openweathermap.org/img/w/%@.png";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.collectionData = [NSMutableArray array];
    
    UIBarButtonItem* aButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onClose)];
    
    self.navigationItem.leftBarButtonItem = aButton;
   
    [self showSpinner];
}

-(void)downloadData
{
    unitStr = [[Settings instance] currentSettings][kUnit];
    
    [DataManager instance].delegate = self;
    [[DataManager instance] downloadDataWithLatitude:self.place.coordinate.latitude andLongitude:self.place.coordinate.longitude andUnits:unitStr];
}



-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)onClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.collectionData count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell* aCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
   
    
    return aCell;
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        WeatherCollectionReusableView* reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WeatherHeader" forIndexPath:indexPath];
        
        NSDictionary* dict = self.collectionData[indexPath.section];
        
        reusableview.lblDate.text = dict[@"date"];
        
        return reusableview;
    }
    
    
    return nil;
}


#pragma mark

#pragma mark -UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    WeatherCollectionViewCell* aCell = (WeatherCollectionViewCell*)cell;
    
    NSDictionary* dict = self.collectionData[indexPath.section];
    WeatherInfo* aInfo = dict[@"info"];
    
    aCell.lblDescription.text = aInfo.desc;
    aCell.lblTemp.text = [NSString stringWithFormat:@"%d%@",(int)aInfo.temperature,[unitStr isEqualToString:kMetric] ? @"°C" : @"°F"];
    aCell.lblWind.text = [NSString stringWithFormat:@"%.1f%@",aInfo.wind,[unitStr isEqualToString:kMetric] ? @"m/s" : @"mi/h"];
    aCell.lblHum.text = [NSString stringWithFormat:@"%d%%",(int)aInfo.humidity];
        
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:iconAddress,aInfo.iconID]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    aCell.imgWeather.image = image;

}





-(void)weatherInfo:(NSDictionary*)json
{
    NSArray* arr = json[@"list"];
    
    for (NSDictionary* dict in arr) {
        
        NSMutableDictionary* mainDict = [NSMutableDictionary dictionary];
        
        mainDict[@"date"] = dict[@"dt_txt"];
        
        WeatherInfo* aInfo = [WeatherInfo new];
        aInfo.wind = [dict[@"wind"][@"speed"] floatValue];
        aInfo.humidity = [dict[@"main"][@"humidity"] floatValue];
        aInfo.temperature = [dict[@"main"][@"temp"] floatValue];
        
        NSArray* arrWeather = dict[@"weather"];
        NSDictionary* dictWeather = arrWeather[0];
        
        aInfo.iconID = dictWeather[@"icon"];
        aInfo.desc = dictWeather[@"description"];
        
        mainDict[@"info"] = aInfo;
        
        [self.collectionData addObject:mainDict];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [activityIndicator removeFromSuperview];
        [self.collectionView reloadData];
        
    });
    
}

-(void)onError:(NSError*)error message:(NSString*)msg
{
    NSString* aMsg = msg ?: [error localizedDescription];
   
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"Error" message:aMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:action];
    
    [self presentViewController:ac animated:YES completion:nil];
}



-(void)showSpinner
{
    UIWindow* aWindow = [[UIApplication sharedApplication] keyWindow];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.color = [UIColor blackColor];
    
    
    activityIndicator.userInteractionEnabled = NO;
    [activityIndicator startAnimating];
    
    [aWindow addSubview:activityIndicator];
    [activityIndicator sizeToFit];
    
    CGRect rect = activityIndicator.frame;
    
    CGFloat x = (aWindow.bounds.size.width - activityIndicator.frame.size.width) / 2;
    CGFloat y = (aWindow.bounds.size.height - activityIndicator.frame.size.height) / 2;
    
    rect.origin.x = x;
    rect.origin.y = y;
    
    activityIndicator.frame = rect;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [activityIndicator removeFromSuperview];
    
    [super viewWillDisappear:animated];
}


@end
