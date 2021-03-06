//
//  DMRecognizerViewController.m
//  DMRecognizer
//
// Copyright 2010, Nuance Communications Inc. All rights reserved.
//
// Nuance Communications, Inc. provides this document without representation 
// or warranty of any kind. The information in this document is subject to 
// change without notice and does not represent a commitment by Nuance 
// Communications, Inc. The software and/or databases described in this 
// document are furnished under a license agreement and may be used or 
// copied only in accordance with the terms of such license agreement.  
// Without limiting the rights under copyright reserved herein, and except 
// as permitted by such license agreement, no part of this document may be 
// reproduced or transmitted in any form or by any means, including, without 
// limitation, electronic, mechanical, photocopying, recording, or otherwise, 
// or transferred to information storage and retrieval systems, without the 
// prior written permission of Nuance Communications, Inc.
// 
// Nuance, the Nuance logo, Nuance Recognizer, and Nuance Vocalizer are 
// trademarks or registered trademarks of Nuance Communications, Inc. or its 
// affiliates in the United States and/or other countries. All other 
// trademarks referenced herein are the property of their respective owners.
//

#import "DMRecognizerViewController.h"

/**
 * The login parameters should be specified in the following manner:
 * 
 * const unsigned char SpeechKitApplicationKey[] =
 * {
 *     0x38, 0x32, 0x0e, 0x46, 0x4e, 0x46, 0x12, 0x5c, 0x50, 0x1d,
 *     0x4a, 0x39, 0x4f, 0x12, 0x48, 0x53, 0x3e, 0x5b, 0x31, 0x22,
 *     0x5d, 0x4b, 0x22, 0x09, 0x13, 0x46, 0x61, 0x19, 0x1f, 0x2d,
 *     0x13, 0x47, 0x3d, 0x58, 0x30, 0x29, 0x56, 0x04, 0x20, 0x33,
 *     0x27, 0x0f, 0x57, 0x45, 0x61, 0x5f, 0x25, 0x0d, 0x48, 0x21,
 *     0x2a, 0x62, 0x46, 0x64, 0x54, 0x4a, 0x10, 0x36, 0x4f, 0x64
 * };
 * 
 * Please note that all the specified values are non-functional
 * and are provided solely as an illustrative example.
 * 
 */
const unsigned char SpeechKitApplicationKey[] = {0x4d, 0x9e, 0xa9, 0x97, 0x22, 0xb3, 0x7e, 0xeb, 0x1c, 0x5e, 0x62, 0xc7, 0xbf, 0xa3, 0x4c, 0x11, 0xd7, 0xac, 0x95, 0x73, 0x78, 0x17, 0x74, 0x19, 0x82, 0x9f, 0xa9, 0xd9, 0x3b, 0x2e, 0xc9, 0x89, 0xcc, 0x72, 0x20, 0xee, 0x25, 0x9e, 0xda, 0x41, 0xfc, 0x3c, 0x09, 0xbc, 0xdf, 0x55, 0xcd, 0xb7, 0x01, 0x62, 0x2a, 0x79, 0x79, 0x9e, 0x92, 0xfb, 0x3d, 0x3c, 0xd5, 0x79, 0x6a, 0x9e, 0x02, 0x36};

@implementation DMRecognizerViewController
@synthesize recordButton,searchBox,serverBox,portBox,alternativesDisplay,vuMeter,voiceSearch;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    /**    
     * The login parameters should be specified in the following manner:
     *
     *  [SpeechKit setupWithID:@"ExampleSpeechKitSampleID"
     *                    host:@"ndev.server.name"
     *                    port:1000
     *                  useSSL:NO
     *                delegate:self];
     *
     * Please note that all the specified values are non-functional
     * and are provided solely as an illustrative example.
     */ 

    [SpeechKit setupWithID:@"NMDPTRIAL_evinitsky20141223221003"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:self];
    
	// Set earcons to play
	//SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	//SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	
	//[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	//[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];

    // Debug - Uncomment this code and fill in your server and port below, and set
    // the Main Window nib to MainWindow_Debug (in DMRecognizer-Info.plist)
    // if you need the ability to change servers in DMRecognizer
    //[serverBox setText:@""];
    //[portBox setText:@""];

    
    // Allow us to reset the relevant variables by setting notifcations for resignation
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [recordButton release];
    [searchBox release];
    [serverBox release];
    [portBox release];
    [alternativesDisplay release];
    [vuMeter release];
    [recognitionType release];
	[languageType release];
    
    [voiceSearch release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Actions
- (void)initializeRecord {
    if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;

        alternativesDisplay.text = @"";
        
        if (recognitionType.selectedSegmentIndex == 0) {
            /* 'Search' is selected */
            detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
            recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        }
        else {
            /* 'Dictation' is selected */
            detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
            recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        }
        
        switch (languageType.selectedSegmentIndex) {
            case 0:
                langType = @"en_US";
                break;
            case 1:
                langType = @"en_GB";
                break;
            case 2:
                langType = @"fr_FR";
                break;
            case 3:
                langType = @"de_DE";
                break;
            default:
                langType = @"en_US";
                break;
        }
        /* Nuance can also create a custom recognition type optimized for your application if neither search nor dictation are appropriate. */
        
        NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%lul.", recoType, langType, (unsigned long)detectionType);

        if (voiceSearch) [voiceSearch release];
        
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
}
- (IBAction)recordButtonAction: (id)sender {
    [searchBox resignFirstResponder];
    [serverBox resignFirstResponder];
    [portBox resignFirstResponder];
    
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        [self initializeRecord];
    }
}

- (IBAction)serverUpdateButtonAction: (id)sender {
    [searchBox resignFirstResponder];
    [serverBox resignFirstResponder];
    [portBox resignFirstResponder];
    
    if (voiceSearch) [voiceSearch cancel];
    
    [SpeechKit destroy];
}

#pragma mark -
#pragma mark VU Meter

- (void)setVUMeterWidth:(float)width {
    if (width < 0)
        width = 0;
    
    CGRect frame = vuMeter.frame;
    frame.size.width = width+10;
    vuMeter.frame = frame;
}

- (void)updateVUMeter {
    float width = (90+voiceSearch.audioLevel)*5/2;
    
    [self setVUMeterWidth:width];    
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

#pragma mark -
#pragma mark SpeechKitDelegate methods

- (void) destroyed {
    // Debug - Uncomment this code and fill in your app ID below, and set
    // the Main Window nib to MainWindow_Debug (in DMRecognizer-Info.plist)
    // if you need the ability to change servers in DMRecognizer
    //
    //[SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
    //                  host:INSERT_YOUR_HOST_ADDRESS_HERE
    //                  port:INSERT_YOUR_HOST_PORT_HERE[[portBox text] intValue]
    //                useSSL:NO
    //              delegate:self];
    //
	// Set earcons to play
	//SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	//SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	//SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	//
	//[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	//[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	//[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];    
}

#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    [self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    [recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 

    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    if (numOfResults > 0){
        // If we do detect sentences, count the number of occurence of some keyword.
        NSString *str = [results firstResult];
        str = [str lowercaseString];
        NSUInteger count = 0, length = [str length];
        NSRange range = NSMakeRange(0, length);
        
        // The keyword is set to "operator" right now.
        while(range.location != NSNotFound)
        {
            range = [str rangeOfString: @"operator" options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }

        // Append the result of keyword search.
        searchBox.text = [[results firstResult] stringByAppendingString:[NSString stringWithFormat:@"\nKeyword count: %i", (int)count]];
    }
    
	if (numOfResults > 1) 
		alternativesDisplay.text = [[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"];

	[voiceSearch release];
	voiceSearch = nil;
    
    // Decreased the delay to decrease latency. This might cause a problem but I don't see it yet.
    [self performSelector:@selector(initializeRecord) withObject:nil afterDelay:.05];
}


- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 
    
    transactionState = TS_IDLE;
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];

    alternativesDisplay.text = @"(Error)";
    
	[voiceSearch release];
	voiceSearch = nil;
    [self performSelector:@selector(initializeRecord) withObject:nil afterDelay:.5];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchBox)
    {
        [searchBox resignFirstResponder];
    }
    else if (textField == serverBox)
    {
        [serverBox resignFirstResponder];
    }
    else if (textField == portBox)
    {
        [portBox resignFirstResponder];
    }
    return YES;
}

#pragma mark delegateNotifications
- (void)applicationWillResignActive:(NSNotification *)notification {
    _numHits = 0;
}

@end
