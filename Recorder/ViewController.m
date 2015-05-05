
//

#import "ViewController.h"
#import "AppDelegate.h"
#import<AVFoundation/AVFoundation.h>
#import "Rec_customview.h"
#import <JTHamburgerButton/JTHamburgerButton.h>
#define kTimeInterval 0.1

@interface ViewController ()
{
    AppDelegate *App_delegate;
    NSString *path;
    AVAudioRecorder *audio_recorder;
    Rec_customview *cust_view;
    UIImageView *card_view;
    UIButton *rec_btn;
    NSTimer *timer;
    JTHamburgerButton *stop_btn;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    App_delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    cust_view=[[Rec_customview alloc]initWithFrame:CGRectMake(0, 112,320 , 244)];
    [self.view addSubview:cust_view];
    card_view=[[UIImageView alloc]initWithFrame:CGRectMake(150,87 ,70 ,70 )];
    card_view.image=[UIImage imageNamed:@"recordbutton.png"];
    [cust_view addSubview:card_view];
    rec_btn=[[UIButton alloc]initWithFrame:CGRectMake(150,87 ,70 ,70 )];
    //[rec_btn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [cust_view addSubview:rec_btn];
    
    stop_btn=[[JTHamburgerButton alloc]initWithFrame:CGRectMake(150,500 ,70 ,70 )];
    [stop_btn addTarget:self action:@selector(stop_rec:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop_btn];
    
    [stop_btn setCurrentMode:JTHamburgerButtonModeArrow];

    
    

}
- (void)stop_rec:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeArrow){
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeCross];
        [self record];
    }
    else{
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeArrow];
        timer=nil;
        [timer invalidate];
        [audio_recorder stop];
        [cust_view setNeedsDisplay];
    }
   
}

-(BOOL)record
{
    @try
    {
        
        NSError *error;
        
        App_delegate.settings = [NSMutableDictionary dictionary];
        [App_delegate.settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [App_delegate.settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
        [App_delegate.settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [App_delegate.settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [App_delegate.settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [App_delegate.settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [App_delegate.settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
        App_delegate.searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        App_delegate.documentPath   = [App_delegate.searchPaths objectAtIndex: 0];
        App_delegate.filemanager    = [NSFileManager defaultManager];
        path = [App_delegate.filepath stringByAppendingPathComponent:[self dateString]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:App_delegate.filepath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:App_delegate.filepath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        NSURL *url = [NSURL fileURLWithPath:path];
        audio_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:App_delegate.settings error:&error];
        if (!audio_recorder)
        {
            NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
            return NO;
        }
        
        audio_recorder.delegate             =       self;
        audio_recorder.meteringEnabled      =       YES;
        AVAudioSession  *   audioSession    =       [AVAudioSession sharedInstance];
        NSError *err                        =        nil;
        [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
        [audio_recorder prepareToRecord];
        if (![audio_recorder prepareToRecord])
        {
            NSLog(@"Error: Prepare to record failed");
            return NO;
        }
        
        [audio_recorder record];
        if (![audio_recorder record])
        {
            NSLog(@"Error: Record failed");
            return NO;
        }
        timer=[NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(waveViewUpdate) userInfo:nil repeats:YES];

        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
        return NO;
    }
    
    
    
}

- (NSString *) dateString
{
    @try {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat  =   @"ddMMMYY_hhmmssa";
        NSString *str1        =   [@"Rec_" stringByAppendingString:[formatter stringFromDate:[NSDate date]]];
        NSString *str2        =   [str1 stringByAppendingString:@".wav"];
        return str2;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)waveViewUpdate
{
    @try
    {
        [audio_recorder updateMeters];
        float volume=[audio_recorder averagePowerForChannel:0];
        float positive_vol=-volume;
        switch ((int)positive_vol)
        {
            case 0:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:120];
                break;
            case 1:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:119];
                break;
            case 2:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:119];
                break;
            case 3:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:119];
                break;
            case 4:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:118];
                break;
            case 5:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:117];
                break;
            case 6:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:116];
                break;
            case 7:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:115];
                break;
            case 8:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:114];
                break;
            case 9:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:113];
                break;
            case 10:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:112];
                break;
            case 11:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:105];
                break;
            case 12:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:103];
                break;
            case 13:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:100];
                break;
            case 14:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:97];
                break;
            case 15:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:94];
                break;
            case 16:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:91];
                break;
            case 17:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:88];
                break;
            case 18:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:85];
                break;
            case 19:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:82];
                break;
            case 20:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:79];
                break;
            case 21:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:75];
                break;
            case 22:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:74];
                break;
            case 23:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:71];
                break;
            case 24:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:68];
                break;
            case 25:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:65];
                break;
            case 26:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:63];
                break;
            case 27:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:61];
                break;
            case 28:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:60];
                break;
            case 29:
                
            case 30:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:57];
                break;
            case 31:
               
            case 32:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:56];
                break;
            case 33:
               
            case 34:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:55];
                break;
            case 35:
               
            case 36:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:54];
                break;
            case 37:
               
            case 38:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:53];
                break;
            case 39:
               
            case 40:
             
            case 41:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:52];
                break;
            case 42:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:51];
                break;
            case 43:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:50];
                break;
            case 44:
               
            case 45:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:49];
                break;
            case 46:
               
            case 47:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:48];
                break;
            case 48:
               
            case 49:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:47];
                break;
            case 50:
                
            case 51:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:46];
                break;
            case 52:
               
            case 53:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:45];
                break;
            case 54:
                
            case 55:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:44];
                break;
            case 56:
               
            case 57:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:43];
                break;
            case 58:
               
            case 59:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:42];
                break;
            case 60:
               
            case 61:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:41];
                break;
            case 62:
               
            case 63:
                
            case 64:
               
            case 65:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:40];
                break;
            case 66:
               
            case 67:
                
            case 68:
                
            case 69:
               
            case 70:
                
            case 71:
              
            case 72:
                
            case 73:
               
            case 74:
                
            case 75:
                
            case 76:
               
            case 77:
               
            case 78:
                
            case 79:
               
            case 80:
                
            case 81:
               
            case 82:
                
            case 83:
            case 84:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:36];
                break;
            case 85:
                
            case 86:
                
            case 87:
                
            case 88:
               
            case 89:
               
            case 90:
                
            case 91:
                
            case 92:
               
            case 93:
               
            case 94:
               
            case 95:
            case 96:
                
            case 97:
                
            case 98:
               
            case 99:
                
            case 100:
               
            case 101:
            case 102:
                
            case 103:
                
            case 104:
               
            case 105:
               
            case 106:
                
            case 107:
                
            case 108:
                
            case 109:
               
            case 110:
                
            case 111:
                
            case 112:
                
            case 113:
                
            case 114:
                
            case 115:
              
            case 116:
               
            case 117:
               
            case 118:
               
            case 119:
                
            case 120:
               
            case 121:
                
            case 122:
                
            case 123:
               
            case 124:
                
            case 125:
                
            case 126:
               
            case 127:
               
            case 128:
               
            case 129:
               
            case 130:
               
            case 131:
                
            case 132:
                
            case 133:
                
            case 134:
                
            case 135:
                
            case 136:
               
            case 137:
               
            case 138:
               
            case 139:
                
            case 140:
                
            case 141:
                
            case 142:
               
            case 143:
               
            case 144:
               
            case 145:
               
            case 146:
                
            case 147:
               
            case 148:
                
            case 149:
                
            case 150:
               
            case 151:
               
            case 152:
               
            case 153:
               
            case 154:
                
            case 155:
                
            case 156:
                
            case 157:
               
            case 158:
               
            case 159:
                
            case 160:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:35];
                break;
                
            default:
                [cust_view setNeedsDisplay];
                [cust_view setZeroPointValue:0];
                break;
        }
        
        
        
        
        
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    
    
}


@end
