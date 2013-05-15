//
//  ViewController.m
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if([preferences stringForKey:@"usernameForVolsbbApp"]){
        [_username setText:[preferences stringForKey:@"usernameForVolsbbApp"]] ;
        [_password setText:[preferences stringForKey:@"passwordForVolsbbApp"]] ;
    }
}

- (void)viewDidUnload
{
    //[self setPassword:nil];
    //[self setUsername:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //STEP 1 Construct Panels

    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)retrieveResponseSync:(id)sender
{
    [_status setText:@"Logging Out..."];
    NSString *post = @"nothing";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://phc.prontonetworks.com/cgi-bin/authlogout"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (IBAction)retrieveResponseAsync:(id)sender 
{
//
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_status setText:@"Logging In...."];
    
    NSString *segment1 = @"userid=";
    segment1 = [segment1 stringByAppendingString: _username.text];
    segment1 = [segment1 stringByAppendingString:@"&password="];
    segment1 = [segment1 stringByAppendingString:_password.text];
    segment1 = [segment1 stringByAppendingString:@"&serviceName=ProntoAuthentication"];
    
    
    
    NSData *postData = [segment1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://phc.prontonetworks.com/cgi-bin/authlogin"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}





- (void)connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response recieved");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    NSLog(@"Data recieved");    
    
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([responseString rangeOfString:@"Successful Pronto Authentication"].location != NSNotFound) {
        [_status setText:@"Logged in"];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences removeObjectForKey:@"usernameForVolsbbApp"];
        [preferences removeObjectForKey:@"passwordForVolsbbApp"];
        [preferences setObject:_username.text forKey:@"usernameForVolsbbApp"];
        [preferences setObject:_password.text forKey:@"passwordForVolsbbApp"];
    }
    else if ([responseString rangeOfString:@"You are already logged in"].location != NSNotFound){
        [_status setText:@"Already Logged In"];
    }
    else if ([responseString rangeOfString:@"Logout successful"].location != NSNotFound){
        [_status setText:@"Logged Out"];
    }
    else if ([responseString rangeOfString:@"Sorry, that account does not exist."].location != NSNotFound){
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops." message:@"Sorry, that account does not exist." delegate:self cancelButtonTitle:@"Alright" otherButtonTitles: nil ];
    
        [alert show];
    
    }
    else if ([responseString rangeOfString:@"Sorry, please check your username and password and try again."].location != NSNotFound){
        [_status setText:@"Invalid Username/Password"];
    }
    else if ([responseString rangeOfString:@"Logout Failure"].location != NSNotFound){
        [_status setText:@"Already Logged Out"];
    }

    
    
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UILocalNotification *loggedIn = [[UILocalNotification alloc] init];
    if (loggedIn){
        loggedIn.alertBody = @"Logged In, or Out, whatever you wanted.";
    }
    
    [app presentLocalNotificationNow:loggedIn];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
