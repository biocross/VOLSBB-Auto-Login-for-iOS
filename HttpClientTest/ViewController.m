//
//  ViewController.m
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


@synthesize response;
@synthesize status;
@synthesize username;
@synthesize password;

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
}

- (void)viewDidUnload
{
    [self setPassword:nil];
    [self setUsername:nil];
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
    [status setText:@"Logging Out..."];
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
    
    [status setText:@"Logging In...."];
    
    NSString *segment1 = @"userid=";
    segment1 = [segment1 stringByAppendingString: username.text];
    segment1 = [segment1 stringByAppendingString:@"&password="];
    segment1 = [segment1 stringByAppendingString:password.text];
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
    NSLog(@"Data recieved");    
    
    //NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //[response setText:responseString];
    //[status setText:@"Logged in, or out, whatever you wanted.."];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:@"Logged In, or Out, whatever you wanted." delegate:self cancelButtonTitle:@"Roger That" otherButtonTitles: nil ];
    
    [alert show];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
