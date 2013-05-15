//
//  ViewController.h
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, retain) IBOutlet UILabel* status;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;


-(IBAction)retrieveResponseAsync:(id)sender;
- (IBAction)retrieveResponseSync:(id)sender;


@end
