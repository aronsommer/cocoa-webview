//
//  AppDelegate.h
//  CocoaWebView
//
//  Aron Sommer 2022
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, WKUIDelegate, WKNavigationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSTextField *adressTextField;

- (IBAction)homePage:(id)sender;
- (IBAction)localHost:(id)sender;
- (IBAction)goToPage:(id)sender;
- (IBAction)goBackPage:(id)sender;
- (IBAction)goForwardPage:(id)sender;
- (IBAction)gitAction:(id)sender;
- (IBAction)zipAction:(id)sender;

- (void)loadFile;
- (BOOL)validateUrl:(NSString*)url;
- (void)loadPage:(NSString*)url;

@end
