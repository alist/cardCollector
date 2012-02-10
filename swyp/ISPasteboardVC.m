//
//  ISPasteboardVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardVC.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+URLEncoding.h"
#import <CoreLocation/CoreLocation.h>

@implementation ISPasteboardVC

@synthesize pasteboardItems;
@synthesize swypWorkspace;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Pasteboard", @"The pasteboard.") 
                                                        image:[UIImage imageNamed:@"paperclip"] tag:2];
        
        swypSwypableContentSuperview * contentSuperView	=	[[swypSwypableContentSuperview alloc] initWithContentDelegate:self workspaceDelegate:[self swypWorkspace] frame:self.view.frame];
        self.view = contentSuperView;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, screenSize.height-(212+49+20), 320, 212);
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin);
        
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
        imageScrollView.showsHorizontalScrollIndicator = YES;
        [self.view addSubview:imageScrollView];
        
        imageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 212)];
        imageView.hidden = YES;
        [imageScrollView addSubview:imageView];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 212)];
        textView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:18];
        
        textView.hidden = YES;
        [self.view addSubview:textView];
        
        _swypWorkspace = [[swypWorkspaceViewController alloc] init];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	[[_swypWorkspace contentManager] setContentDataSource:self];
}

- (void)updatePasteboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (!pasteboardItems || ![pasteboardItems isEqualToArray:pasteBoard.items]) {
        pasteboardItems = pasteBoard.items;
        
        self.tabBarItem.badgeValue = @"!";
        
        imageView.image = nil;
        
        if (pasteBoard.image) {
            UIImage *croppedImage = [pasteBoard.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:imageView.size interpolationQuality:0.8];
            [imageView setImage:croppedImage];
            textView.text = nil;
        } else if (pasteBoard.URL) {
            textView.text = [pasteBoard.URL absoluteString];
        } else if (pasteBoard.string) {
            
            NSDataDetector *addressDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeAddress error:NULL];
            
            NSTextCheckingResult *match = [addressDetector firstMatchInString:pasteBoard.string options:0 range:NSMakeRange(0, pasteBoard.string.length)];
            
            if (match) {
                address = [pasteBoard.string substringWithRange:match.range];
                NSString *urlEncodedAddress = [address urlEncodeUsingEncoding:NSUTF8StringEncoding];
                NSInteger scale = [UIScreen mainScreen].scale;
                [imageView setPathToNetworkImage:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?sensor=false&size=320x212&center=%@&zoom=13&scale=%i&markers=blue%%7C%@",
                        urlEncodedAddress, scale, urlEncodedAddress]];
                textView.text = pasteBoard.string;
            } else {
                textView.text = pasteBoard.string;
                address = nil;
            }
        }
        
        CGRect frame = textView.frame;
        frame.size.height = textView.contentSize.height;
        textView.frame = frame;
            
        textView.hidden = (textView.text.length > 0) ? NO : YES;
        /*  Because the map image is loaded asynchronously, the image may not be set yet.
            This is why we have to explicitly check for address. */
        imageView.hidden = (imageView.image || address) ? NO : YES;
    } else {
        self.tabBarItem.badgeValue = nil;
    }
    
    [_delegate datasourceSignificantlyModifiedContent:self];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - swyp
#pragma mark swypSwypableContentSuperviewContentDelegate
-(NSString*)contentIDForSwypableSubview:(UIView *)view withinSwypableContentSuperview:(swypSwypableContentSuperview *)superview{
	NSArray * content = [self idsForAllContent];
	return [content objectAtIndex:0];
}
-(BOOL)subview:(UIView *)subview isSwypableWithSwypableContentSuperview:(swypSwypableContentSuperview *)superview{
	if (subview == imageView || subview == textView){
		NSArray * content = [self idsForAllContent];
		return (ArrayHasItems(content));
	}
	return FALSE;
}


#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)	supportedFileTypesForReceipt{
	return [NSArray arrayWithObjects:nil];
}

-(BOOL) delegateWillHandleDiscernedStream:(swypDiscernedInputStream*)discernedStream wantsAsData:(BOOL *)wantsProvidedAsNSData inConnectionSession:(swypConnectionSession*)session{
	if ([[self supportedFileTypesForReceipt] containsObject:[discernedStream streamType]]){
		*wantsProvidedAsNSData = TRUE;
		return TRUE;
	}
	return FALSE;
}

#pragma mark swypContentDataSourceProtocol
- (NSArray*)		idsForAllContent{
	if (!imageView.image) {
		return nil;
    }
	return [NSArray arrayWithObject:@"MODEL_CURRENT_PASTEBOARD_ITEM"];
}
- (UIImage *)		iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize {
    UIGraphicsBeginImageContext(self.view.frame.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return viewImage;
}

- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:[NSString imageJPEGFileType],[NSString imagePNGFileType], nil];
}
- (NSInputStream*)	inputStreamForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type	length: (NSUInteger*)contentLengthDestOrNULL;{
	NSData * streamData = nil;
    
    if ([type isFileType:[NSString imageJPEGFileType]]){
        streamData = UIImageJPEGRepresentation(imageView.image, 0.8);
    } else if ([type isFileType:[NSString imagePNGFileType]]){
		streamData = UIImagePNGRepresentation(imageView.image);
	}
	
	*contentLengthDestOrNULL	=	[streamData length];
	return [NSInputStream inputStreamWithData:streamData];
}
-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
	_delegate	=	delegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return _delegate;
}

@end
