//
//  AppDelegate.m
//  CocoaWebView
//
//  Aron Sommer 2022
//

#import "AppDelegate.h"

@implementation AppDelegate

// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.

- (void)awakeFromNib
{
    
}

// Tells the delegate when the app has finished launching.

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    
    //[self homePage:self];
    [self loadFile];
    
    // Say hello :)
    NSSpeechSynthesizer * syn = [[NSSpeechSynthesizer alloc] init];
    [syn startSpeakingString:@"Hello"];
    NSLog(@"App has started");
}

- (void)loadFile
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"Content/index" ofType:@"html"];

    NSURL *url = [NSURL fileURLWithPath:filePath];

    [_webView loadFileURL:url allowingReadAccessToURL:[url URLByDeletingLastPathComponent]];
}

// Tells the delegate that the app is about to terminate
- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"Exit App");
    // execute bash script to stop server
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] pathForResource:@"caddy-stop" ofType:@""], nil]];
        [task launch];
}

#pragma mark Action methods

- (IBAction)homePage:(id)sender
{
    //[self loadPage:@"https://www.google.com"];
    [self loadFile];
}

- (IBAction)localHost:(id)sender
{
    // execute bash script to start server
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] pathForResource:@"caddy-start" ofType:@""], nil]];
        [task launch];
    
    // wait 3 seconds
    [NSThread sleepForTimeInterval:3.0f];
    
    // open local host
    //[self loadPage:@"http://127.0.0.1:8000/"]; // python2 server
    [self loadPage:@"http://127.0.0.1:2015/"]; // caddy server
    //[self loadPage:@"http://localhost:2015"];
}

- (IBAction)goToPage:(id)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@", @"https://", [_adressTextField stringValue]];
    
    if (![self validateUrl:url])
    {
        return;
    }
    
    [self loadPage:url];
}

- (IBAction)goBackPage:(id)sender
{
    if (![_webView canGoBack])
    {
        return;
    }
    
    [_webView goBack];
}

- (IBAction)goForwardPage:(id)sender
{
    if (![_webView canGoForward])
    {
        return;
    }
    
    [_webView goForward];
}

- (IBAction)gitAction:(id)sender
{
    // execute bash script to clone github repo
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] pathForResource:@"git-action" ofType:@""], nil]];
    // do things after completion
        task.terminationHandler = ^(NSTask *task){
            NSLog(@"Git action has finished");
        };
        [task launch];
}

- (IBAction)zipAction:(id)sender
{
    // execute bash script to download zip    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] pathForResource:@"zip-action" ofType:@""], nil]];
        [task launch];
}

#pragma mark Helper methods

- (BOOL)validateUrl:(NSString*)url;
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

- (void)loadPage:(NSString*)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
