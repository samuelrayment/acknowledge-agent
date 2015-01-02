//
//  SerialCommunication.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "SerialCommunication.h"
#import <IOKit/IOBSD.h>
#import <IOKit/serial/IOSerialKeys.h>
#import <sys/ioctl.h>

@interface SerialCommunication () {
    struct termios gOriginalTTYAttrs;
    io_iterator_t serialPortIterator;
}

@property int serialFileDescriptor;
@property BOOL connected;

@end

@implementation SerialCommunication

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _serialFileDescriptor = -1;
        _connected = NO;
    }
    return self;
}

- (BOOL)isConnected {
    return _serialFileDescriptor != -1;
}

- (NSString*)connectToDevice:(NSString*)deviceName {
    int success;
    speed_t baudRate = B9600;
    // close the port if it is already open
    if (_serialFileDescriptor != -1) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
        
        // wait for the reading thread to die
        //while(readThreadRunning);
        
        // re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
        sleep(1.0);
    }
    sleep(1.0);
    
    // c-string path to serial-port file
    const char *bsdPath = [deviceName cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Hold the original termios attributes we are setting
    struct termios options;
    
    // receive latency ( in microseconds )
    unsigned long mics = 3;
    
    // error message string
    NSString *errorMessage = nil;
    
    // open the port
    //     O_NONBLOCK causes the port to open without any delay (we'll block with another call)
    _serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
    
    if (_serialFileDescriptor == -1) {
        // check if the port opened correctly
        errorMessage = @"Error: couldn't open serial port";
    } else {
        // TIOCEXCL causes blocking of non-root processes on this serial-port
        success = ioctl(_serialFileDescriptor, TIOCEXCL);
        if ( success == -1) {
            errorMessage = @"Error: couldn't obtain lock on serial port";
        } else {
            success = fcntl(_serialFileDescriptor, F_SETFL, 0);
            if ( success == -1) {
                // clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
                errorMessage = @"Error: couldn't obtain lock on serial port";
            } else {
                // Get the current options and save them so we can restore the default settings later.
                success = tcgetattr(_serialFileDescriptor, &gOriginalTTYAttrs);
                if ( success == -1) {
                    errorMessage = @"Error: couldn't get serial attributes";
                } else {
                    // copy the old termios settings into the current
                    //   you want to do this so that you get all the control characters assigned
                    options = gOriginalTTYAttrs;
                    
                    /*
                     cfmakeraw(&options) is equivilent to:
                     options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
                     options->c_oflag &= ~OPOST;
                     options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
                     options->c_cflag &= ~(CSIZE | PARENB);
                     options->c_cflag |= CS8;
                     */
                    cfmakeraw(&options);
                    
                    // set tty attributes (raw-mode in this case)
                    success = tcsetattr(_serialFileDescriptor, TCSANOW, &options);
                    if ( success == -1) {
                        errorMessage = @"Error: coudln't set serial attributes";
                    } else {
                        // Set baud rate (any arbitrary baud rate can be set this way)
                        success = ioctl(_serialFileDescriptor, IOSSIOSPEED, &baudRate);
                        if ( success == -1) {
                            errorMessage = @"Error: Baud Rate out of bounds";
                        } else {
                            // Set the receive latency (a.k.a. don't wait to buffer data)
                            success = ioctl(_serialFileDescriptor, IOSSDATALAT, &mics);
                            if ( success == -1) {
                                errorMessage = @"Error: coudln't set serial latency";
                            }
                        }
                    }
                }
            }
        }
    }
    
    // make sure the port is closed if a problem happens
    if ((_serialFileDescriptor != -1) && (errorMessage != nil)) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
        [_delegate connectionStateChanged:NO];
    } else {
        [_delegate connectionStateChanged:YES];
    }
    
    return errorMessage;
}


void notificationCallback(void *refcon, io_iterator_t iterator) {
    SerialCommunication *serialComms = (__bridge SerialCommunication*) refcon;
    [serialComms notificationReceived:iterator];
}

- (void)discover {
    IONotificationPortRef notificationPort = IONotificationPortCreate(kIOMasterPortDefault);
    CFRunLoopSourceRef notificationRunLoopSource = IONotificationPortGetRunLoopSource(notificationPort);
    CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop], notificationRunLoopSource, kCFRunLoopDefaultMode);
    
    IOServiceAddMatchingNotification(notificationPort,
                                     kIOMatchedNotification,
                                     IOServiceMatching(kIOSerialBSDServiceValue),
                                     notificationCallback,
                                     (__bridge void *)self, &serialPortIterator);
    // loop through all the serial ports
    [self notificationReceived:serialPortIterator];
}

- (void)notificationReceived:(io_iterator_t) iterator {
    io_object_t serialPort;
    NSString *potentialDevice;
    while ((serialPort = IOIteratorNext(iterator))) {
        // you want to do something useful here
        NSString *deviceString = (__bridge NSString*)IORegistryEntryCreateCFProperty(
                                                                                     serialPort, CFSTR(kIOCalloutDeviceKey),
                                                                                     kCFAllocatorDefault, 0);
        if ([deviceString isEqualToString:@"/dev/cu.usbmodem1411"]) {
            potentialDevice = [deviceString copy];
        }
        
        IOObjectRelease(serialPort);
    }
    if (potentialDevice != nil) {
        [self connectToDevice:potentialDevice];
    }
}

- (void)sendColor:(ChosenState)state {
    uint8_t stateChar;
    switch (state) {
        case Red:
            stateChar = 'R';
            break;
        case Amber:
            stateChar = 'A';
            break;
        case Green:
            stateChar = 'G';
            break;
    }
    [self writeByte:&stateChar];
}

// send a byte to the serial port
- (void) writeByte: (uint8_t *) val {
    ssize_t ret;
    if(_serialFileDescriptor!=-1) {
        ret = write(_serialFileDescriptor, val, 1);
        if (ret == -1) {
            _serialFileDescriptor = -1;
            [_delegate connectionStateChanged:NO];
        }
    }
}

@end

