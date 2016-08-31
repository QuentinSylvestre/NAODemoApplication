//
//  ApiKeySelectionViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 10/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "ApiKeySelectionViewController.h"

@interface ApiKeySelectionViewController ()

@end

@implementation ApiKeySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Api Key Selection";
    
    [self.apiKeySelectionTableView setDelegate:self];
    [self.apiKeySelectionTableView setDataSource:self];
    
    self.apiKeyList = [[NSArray alloc] init];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"apiKeyFile" ofType:@"txt"];
    NSError *error;
    NSString *stringFromFileAtURL = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (stringFromFileAtURL == nil) {
        NSLog(@"Error reading file at %@\n%@", filePath, [error localizedFailureReason]);
    } else {
        self.apiKeyList = [stringFromFileAtURL componentsSeparatedByString:@"\n"];
    }
    
    NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    if (apiKey != nil && ![apiKey isEqualToString:@""]) {
        self.apiKeyTextField.text = apiKey;
    } else {
        self.apiKeyTextField.placeholder = @"Enter or select your API Key";
    }
    
    [self.apiKeyTextField setReturnKeyType:UIReturnKeyDone];
    self.apiKeyTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)validateAction:(id)sender {
    NSLog(@"Entered: %@", self.apiKeyTextField.text);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.apiKeyTextField.text forKey:@"apiKey"];
    [userDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.apiKeyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"apiKeyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *apiKeylabel = [cell viewWithTag:1];
    [apiKeylabel setText:[self.apiKeyList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.apiKeyTextField.text = [self.apiKeyList objectAtIndex:indexPath.row];
}

@end
