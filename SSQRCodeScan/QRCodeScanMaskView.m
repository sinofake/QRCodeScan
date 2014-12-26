//
//  QRCodeScanMaskView.m
//  QRCode
//
//  Created by zhucuirong on 14/12/13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "QRCodeScanMaskView.h"

@implementation QRCodeScanMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scanAreaRect = CGRectZero;
        _themeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85f];
        _scanAreaColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!CGRectEqualToRect(self.scanAreaRect, CGRectZero)) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rects[] =
        {
            //上，左，下，右四个遮罩
            CGRectMake(0, 0, screenSize.width, CGRectGetMinY(self.scanAreaRect)),
            CGRectMake(0, CGRectGetMinY(self.scanAreaRect), CGRectGetMinX(self.scanAreaRect), CGRectGetHeight(self.scanAreaRect)),
            CGRectMake(0, CGRectGetMaxY(self.scanAreaRect), screenSize.width, screenSize.height - CGRectGetMaxY(self.scanAreaRect)),
            CGRectMake(CGRectGetMaxX(self.scanAreaRect), CGRectGetMinY(self.scanAreaRect), screenSize.width - CGRectGetMaxX(self.scanAreaRect), CGRectGetHeight(self.scanAreaRect)),
        };
        
        [self.themeColor setFill];
        // Bulk call to add rects to the current path.
        CGContextAddRects(context, rects, sizeof(rects)/sizeof(rects[0]));
        CGContextFillPath(context);
        
        [self.scanAreaColor setFill];
        CGContextFillRect(context, self.scanAreaRect);
    }
}

- (void)setScanAreaRect:(CGRect)scanAreaRect {
    if (!CGRectEqualToRect(_scanAreaRect, scanAreaRect)) {
        _scanAreaRect = scanAreaRect;
        [self setNeedsDisplay];
    }
}

- (void)setThemeColor:(UIColor *)themeColor {
    if (_themeColor != themeColor) {
        _themeColor = themeColor;
        [self setNeedsDisplay];
    }
}

- (void)setScanAreaColor:(UIColor *)scanAreaColor {
    if (_scanAreaColor != scanAreaColor) {
        _scanAreaColor = scanAreaColor;
        [self setNeedsDisplay];
    }
}

@end
