//
//  HomeViewController.m
//  Weather
//
//  Created by Tomislav Luketic on 5/8/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "HomeViewController.h"
#import "BookMarksTableViewCell.h"
#import "Place.h"
#import "CityViewController.h"
#import "Settings.h"

#import <Contacts/Contacts.h>

@interface HomeViewController ()
{
    BOOL doAddPin;
    BOOL isLoading;
    BOOL isDataInvalidated;
    BOOL userLocationUpdated;
    MKPointAnnotation* dragAnnotation;
    MKPinAnnotationView* dragAnnotationView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) NSMutableArray* tableData;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData = [NSMutableArray array];
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
    
    self.searchBar = [UISearchBar new];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    
    self.mapView.showsBuildings = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookmarksDeleted) name:@"bookmarksDeleted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeSwitched:) name:@"modeSwitched" object:nil];
    
    
    [self loadData];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isDataInvalidated)
    {
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self.tableData removeAllObjects];
        [self reloadTableViewData];
        isDataInvalidated = NO;
    }
}

-(void)loadData
{
    NSData* aData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bookmarks"];
    
    if (aData)
    {
       
          self.tableData =  [NSKeyedUnarchiver unarchiveObjectWithData:aData];
        
          if ([self.tableData count]>0)
          {
        
            [self.mapView addAnnotations:self.tableData];
            
            Place* lastPlace = [self.tableData lastObject];
            
           
              if ([[[Settings instance] currentSettings][kMode] isEqualToString:kDrag])
              {
                  [self createDraggableAnnotation:lastPlace.coordinate];
                  [self.mapView addAnnotation:dragAnnotation];
              }

            
            
              
            
          }
 
        
    }
    
    [self reloadTableViewData];
}

-(void)reloadSavedData
{
    NSData* aData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bookmarks"];
    
    if (aData)
    {
        
        self.tableData =  [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    }
    else
        [self.tableData removeAllObjects];
    
    [self reloadTableViewData];
}

-(void)saveData
{
   NSData* aData = [NSKeyedArchiver archivedDataWithRootObject:self.tableData];
   [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"Bookmarks"];
}


-(void)refreshTableView
{
    
   [self reloadTableViewData];
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
      [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height) animated:YES];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookMarksTableViewCell* aCell = [self.tableView dequeueReusableCellWithIdentifier:@"BookMarksCell"];
    
    
    Place* aPlace = self.tableData[indexPath.row];
    
    aCell.lblTitle.text = aPlace.title2;
    
    return aCell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        
        Place* aPlace = self.tableData[indexPath.row];
        
        [self.mapView removeAnnotation:aPlace];
        
        [self.tableData removeObjectAtIndex:indexPath.row];
        
        [self saveData];
        
        [self reloadTableViewData];
    }
}

#pragma mark



#pragma mark -MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocationUpdated)
    {
        [self zoomToFitMyLocation];
        userLocationUpdated = YES;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    
    if ([annotation class] == [MKPointAnnotation class])
    {
        
        MKPinAnnotationView* annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"DragPin"];
        annView.pinTintColor = [UIColor purpleColor];
        annView.draggable = YES;
        annView.animatesDrop = YES;
        annView.canShowCallout = YES;
        
        annView.leftCalloutAccessoryView = [self createLabelForCallout:annView];
        
        ((MKPointAnnotation*)annotation).title = @" ";
        
        dragAnnotationView = annView;
        return annView;
        
    }
    else
        if ([annotation class] == [Place class])
        {
            MKPinAnnotationView* annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                           reuseIdentifier:@"PlacePin"];
            annView.pinTintColor = [UIColor redColor];
            annView.canShowCallout = YES;
            
            annView.leftCalloutAccessoryView = [self createLabelForCallout:annView];
            annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPinTap)];
            [annView addGestureRecognizer:tap];
            
            return annView;
            
            
        }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    doAddPin = NO;
}



- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    doAddPin = NO;
    
    if ([view.annotation class] == [MKPointAnnotation class])
        view.canShowCallout = NO;
    
    [self selectDraggablePin];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    view.canShowCallout = NO;
    
    if (newState == MKAnnotationViewDragStateEnding)
        [self addAnnotation:view.annotation.coordinate];
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    [self selectDraggablePin];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    UINavigationController* nc = [sb instantiateViewControllerWithIdentifier:@"CityNavigationController"];
    
    CityViewController* vc = (CityViewController*)[nc topViewController];
    
    vc.place = (Place*)view.annotation;
    
    [vc downloadData];
    
    [self presentViewController:nc animated:YES completion:nil];
    
    
    
    [self.mapView deselectAnnotation:view.annotation animated:nil];
    
    
}



#pragma  mark

-(void)zoomToFitMyLocation {
    
    
    CLLocationCoordinate2D coord;
    
    if (dragAnnotation)
        coord = dragAnnotation.coordinate;
    else
        coord = self.mapView.userLocation.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord,1000000,1000000);
    [self.mapView setRegion:region animated:YES];
    
}

-(void)locationAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        self.mapView.showsUserLocation = YES;
    else
    {
        CLLocationManager* aLocationManager = [CLLocationManager new];
        [aLocationManager requestWhenInUseAuthorization];
    }
}



- (IBAction)onMapTap:(UITapGestureRecognizer*)sender {
   
  
    if ([[[Settings instance] currentSettings][kMode] isEqualToString:kDrop])
    {
        
        if ([self.mapView.selectedAnnotations count]>0)
            return;
        
        
        doAddPin = YES;
        NSDictionary* dict = [self makePointsDict:sender];
        [self performSelector:@selector(addDropPin:) withObject:dict afterDelay:0.3];
    }
    else
    {
        if ([self isDraggeblePinAdded])
            return;
        
        doAddPin = YES;
        
        NSDictionary* dict = [self makePointsDict:sender];
        
        [self performSelector:@selector(addDraggablePin:) withObject:dict afterDelay:0.3];
    }

  
    
}


-(NSDictionary*)makePointsDict:(UITapGestureRecognizer*)sender
{
    CGPoint aPoint = [sender locationInView:self.mapView];
    NSDictionary* dict = @{@"x" : @(aPoint.x), @"y" : @(aPoint.y)};
    
    return dict;
}

-(BOOL)isDraggeblePinAdded
{
    for (id<MKAnnotation> ann in self.mapView.annotations) {
        
        if ([ann class] == [MKPointAnnotation class])
            return YES;
        
    }

    return NO;
}

-(void)addDropPin:(NSDictionary*)sender
{
    if (doAddPin && [self.mapView.selectedAnnotations count]==0)
    {
        CGPoint aPoint = CGPointMake([sender[@"x"] floatValue], [sender[@"y"] floatValue]);
        CLLocationCoordinate2D coord = [self.mapView convertPoint:aPoint toCoordinateFromView:self.mapView];
        [self addAnnotation:coord];
    }
}



-(void)addDraggablePin:(NSDictionary*)sender
{
 
    if (doAddPin)
    {
       CGPoint aPoint = CGPointMake([sender[@"x"] floatValue], [sender[@"y"] floatValue]);
       
       CLLocationCoordinate2D coord = [self.mapView convertPoint:aPoint toCoordinateFromView:self.mapView];
       [self createDraggableAnnotation:coord];
       [self addAnnotation:dragAnnotation.coordinate];
    }
}

-(void)createDraggableAnnotation:(CLLocationCoordinate2D)coord
{
    dragAnnotation = [MKPointAnnotation new];
    dragAnnotation.coordinate = coord;
    dragAnnotation.title = @"Drag this pin to bookmark another location";
   
}

-(void)addAnnotation:(CLLocationCoordinate2D)coord
{
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation* aLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [geoCoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        

        
        NSString* aTitle = nil;
        
        if (!error)
        {
            CLPlacemark* aPlacemark = placemarks[0];
            
            aTitle=[aPlacemark.addressDictionary[@"FormattedAddressLines"] componentsJoinedByString:@","];
            
        }
         else
             aTitle = [NSString stringWithFormat:@"(%.7f,%.7f)",coord.latitude,coord.longitude];

        
        
        Place* aPlace = [[Place alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude andTitle:aTitle];
        
        [self.mapView addAnnotation:aPlace];
        [self.tableData addObject:aPlace];
        
        if (![self isDraggeblePinAdded] && dragAnnotation)
            [self.mapView addAnnotation:dragAnnotation];
        
        [self saveData];
        [self refreshTableView];
        
        
    }];

}


-(void)onPinTap
{
    doAddPin = NO;
}

-(UILabel*)createLabelForCallout:(MKPinAnnotationView*)annView
{
    
    NSString* aTitle = [annView.annotation class] == [MKPointAnnotation class] ? ((MKPointAnnotation*)annView.annotation).title :
    ((Place*)annView.annotation).title2 ;
    
    CGRect aFrame = [aTitle boundingRectWithSize:CGSizeMake(200,CGRectGetHeight(annView.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12]} context:nil];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(2,0,200,aFrame.size.height)];
    
    lbl.text = aTitle;
    
    lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.numberOfLines = 0;
    annView.leftCalloutAccessoryView = lbl;
    
    return lbl;

}



-(void)selectDraggablePin
{
    if (dragAnnotationView)
      [self.mapView selectAnnotation:dragAnnotationView.annotation animated:NO];
    
}



#pragma mark -UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* aText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([aText length]>0)
    {
   
        NSMutableArray* arr = [NSMutableArray array];
        
        if ([self.tableData count]==0)
        {
            NSData* aData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bookmarks"];
            self.tableData =  [NSKeyedUnarchiver unarchiveObjectWithData:aData];
        }
    
        [self.tableData enumerateObjectsUsingBlock:^(Place* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         if ([obj.title2 rangeOfString:aText options:NSCaseInsensitiveSearch].length>0)
             [arr addObject:obj];
        
        }];
    
        self.tableData = arr;
       [self reloadTableViewData];
    }
    else
        [self reloadSavedData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
   
}

#pragma mark

-(void)bookmarksDeleted
{
    isDataInvalidated = YES;
}

-(void)modeSwitched:(NSNotification*)aNotification
{
    if ([aNotification.userInfo[@"mode"] isEqualToString:@"drop"])
    {
        [self.mapView removeAnnotation:dragAnnotation];
        dragAnnotation = nil;
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowWeather"])
    {
        
        UINavigationController* nc=(UINavigationController*) segue.destinationViewController;
        
        CityViewController* vc = (CityViewController*)[nc topViewController];
        
        NSIndexPath* aPath = self.tableView.indexPathForSelectedRow;
        
        Place* aPlace = self.tableData[aPath.row];
        
        vc.place = aPlace;
        
        [vc downloadData];
        
    }
}


-(void)reloadTableViewData
{
    self.tableView.tableFooterView = [self makeTableFooterView];
    [self.tableView reloadData];
}

-(UIView*)makeTableFooterView
{
    if ([self.tableData count]>0)
        return [UIView new];
    
    UIView* aView = [[NSBundle mainBundle] loadNibNamed:@"NoBookmarksYet" owner:self options:nil][0];
    
    return aView;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
