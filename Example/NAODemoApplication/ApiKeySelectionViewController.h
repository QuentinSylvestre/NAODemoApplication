//
//  ApiKeySelectionViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 10/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApiKeySelectionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITableView *apiKeySelectionTableView;
@property NSMutableArray *apiKeyList;
@property NSMutableArray *apiKeyNames;

@end
