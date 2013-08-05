//
//  VideoVC.m
//  Swaraj
//
//  Created by DevMacPro on 02/08/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "VideoVC.h"
#import "Constants.h"

#define kVideoHtmlString @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 302\"/></head> <body style=\"background:#000;margin:0px;padding:0px\"> <div><object width=\"302\" height=\"168\"> <param name=\"movie\" value=\"http://www.youtube.com/v/HmkKedAt0v8&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param> <param name=\"wmode\" value=\"transparent\"></param> <embed src=\"http://www.youtube.com/v/HmkKedAt0v8&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"302\" height=\"168\"></embed> </object></div></body></html>"

#define kVideoUrl @"http://www.youtube.com/watch?v=HmkKedAt0v8"


@interface VideoVC ()

@property (strong, nonatomic) IBOutlet UIWebView *videoWebView;
@end

@implementation VideoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

  NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kOverallVideoKey];
  url = [self extractYoutubeID:url];  
  [self embedYouTube:[NSString stringWithFormat:@"http://www.youtube.com/embed/%@", url]
               frame:self.videoWebView.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
  NSString *html = [NSString stringWithFormat:@"<html><head><style type='text/css'>body {background-color: transparent;color: black;}</style></head><body style='margin:0'><iframe width='%f' height='%f' src='%@' frameborder='0' allowfullscreen></iframe></body></html>", frame.size.width, frame.size.height, urlString];
  [self.videoWebView loadHTMLString:html baseURL:nil];
}

- (NSString *)extractYoutubeID:(NSString *)youtubeURL {
  NSString *vID = nil;
  NSString *query = [youtubeURL componentsSeparatedByString:@"?"][1];
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  for (NSString *pair in pairs) {
    NSArray *kv = [pair componentsSeparatedByString:@"="];
    if ([kv[0] isEqualToString:@"v"]) {
      vID = kv[1];
      break;
    }
  }
  return vID;
}

- (IBAction)dismissTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
