//
//  HMSegmentedControl.m
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#define segmentImageTextPadding 7

@interface HMScrollView : UIScrollView
@end

@interface HMSegmentedControl ()

@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorArrowLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray *segmentWidthsArray;
@property (nonatomic, strong) HMScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *sectionViews;
@property (nonatomic, copy) HMCustomView viewBlock;

@end

@implementation HMScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@implementation HMSegmentedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionTitles = sectiontitles;
        self.type = HMSegmentedControlTypeText;
    }
    
    return self;
}

- (id)initWithSectionItems:(NSArray *)sectionitems customViewBlock:(HMCustomView)customViewBlock
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.type = HMSegmentedControlTypeCustom;
        self.viewBlock = customViewBlock;
        self.sectionItems = sectionitems;
    }
    
    return self;
}

- (UIView*)addCustomItemView:(id)obj  index:(NSUInteger)idx
{
    UIView *v = nil;
    if (self.viewBlock)
        v = self.viewBlock(obj, idx);
    if (!self.sectionViews)
        self.sectionViews = [NSMutableArray new];
    if (v)
    {
        [self.sectionViews addObject:v];
        [self.scrollView addSubview:v];
    }
    return v;
}

- (void)setSectionItems:(NSArray *)sectionItems
{
    _sectionItems = sectionItems;
    
    [self.sectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.sectionViews removeAllObjects];
    [self.sectionItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addCustomItemView:obj index:idx];
    }];
    if (self.selectedStyleBlock) {
        self.selectedStyleBlock(self.customViews, self.selectedSegmentIndex);
    }
    [self setNeedsLayout];
}

- (id)initWithSectionImages:(NSArray*)sectionImages sectionSelectedImages:(NSArray*)sectionSelectedImages {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.type = HMSegmentedControlTypeImages;
    }
    
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles {
	self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
		
		if (sectionImages.count != sectiontitles.count) {
			[NSException raise:NSRangeException format:@"***%s: Images bounds (%ld) Dont match Title bounds (%ld)", sel_getName(_cmd), (unsigned long)sectionImages.count, (unsigned long)sectiontitles.count];
        }
		
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
		self.sectionTitles = sectiontitles;
        self.type = HMSegmentedControlTypeTextImages;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.segmentWidth = 0.0f;
    [self commonInit];
}

- (void)commonInit {
    self.scrollView = [[HMScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f];
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.type = HMSegmentedControlTypeText;
    self.indicatorWidthForFixed = 15;
    self.fixIndicatorWidth = NO;
    self.shouldAnimateUserSelection = YES;
    
    self.selectionIndicatorArrowLayer = [CALayer layer];
    self.selectionIndicatorStripLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer.opacity = self.selectionIndicatorBoxOpacity;
    self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
    self.selectionIndicatorBoxOpacity = 0.2;
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [self layoutIfNeeded];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
    _sectionTitles = sectionTitles;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSectionImages:(NSArray *)sectionImages {
    _sectionImages = sectionImages;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];

}

- (void)setSelectionIndicatorLocation:(HMSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation {
	_selectionIndicatorLocation = selectionIndicatorLocation;
	
	if (selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationNone) {
		self.selectionIndicatorHeight = 0.0f;
	}
}

- (void)setSelectionIndicatorBoxOpacity:(CGFloat)selectionIndicatorBoxOpacity
{
    _selectionIndicatorBoxOpacity = selectionIndicatorBoxOpacity;
    
    self.selectionIndicatorBoxLayer.opacity = _selectionIndicatorBoxOpacity;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorStripLayer.cornerRadius = self.selectionIndicatorHeight/2.f;
    self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorColor.CGColor;
    
    if(self.type != HMSegmentedControlTypeCustom) {
        // Remove all sublayers to avoid drawing images over existing ones
        self.scrollView.layer.sublayers = nil;
    }
    
    if (self.type == HMSegmentedControlTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {

            CGFloat stringWidth = 0;
            CGFloat stringHeight = 0;
            CGSize stringSize = [titleString textSizeWithFont:self.font]; 
            stringWidth = stringSize.width+1;
            stringHeight = stringSize.height;
            
            // Text inside the CATextLayer will appear blurry unless the rect values are rounded
            CGFloat y = roundf(CGRectGetHeight(self.frame) - self.selectionIndicatorHeight)/2 - stringHeight/2 + ((self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationUp) ? self.selectionIndicatorHeight : 0);
            y -= 1;
            CGRect rect;
            if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
                rect = CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - stringWidth)/2, y, stringWidth, stringHeight);
            } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                rect = CGRectMake(xOffset, y, [[self.segmentWidthsArray objectAtIndex:idx] floatValue], stringHeight);
            }
            
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = rect;
            titleLayer.fontSize = self.font.pointSize;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = titleString;
            titleLayer.truncationMode = kCATruncationEnd;
            
            if (self.selectedSegmentIndex == idx) {
                titleLayer.foregroundColor = self.selectedTextColor.CGColor;
                titleLayer.transform = CATransform3DScale(titleLayer.transform, 1.1, 1.1, 1);
//                UIFont * font = HPBoldFontWithSize(self.font.pointSize);
                UIFont * font = HPFontWithSize(self.font.pointSize);
                titleLayer.font = (__bridge CFTypeRef)(font.fontName);

            } else {
                titleLayer.foregroundColor = self.textColor.CGColor;
                titleLayer.transform = CATransform3DIdentity;
                titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
            }
            
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
        }];
    } else if (self.type == HMSegmentedControlTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            CGFloat y = roundf(CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2 - imageHeight / 2 + ((self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationUp) ? self.selectionIndicatorHeight : 0);
            CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = rect;
            
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
        }];
    } else if (self.type == HMSegmentedControlTypeTextImages){
		[self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            // When we have both an image and a title, we start with the image and use segmentImageTextPadding before drawing the text.
            // So the image will be left to the text, centered in the middle
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
			
			CGFloat stringHeight = roundf([self.sectionTitles[idx] textSizeWithFont:self.font].height);
            
			CGFloat yOffset = roundf(((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) - (stringHeight / 2));
            
            CGFloat imageXOffset = self.segmentEdgeInset.left; // Start with edge inset
            if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed)
                imageXOffset = self.segmentWidth * idx;
            else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    imageXOffset = imageXOffset + [width floatValue];
                    i++;
                }
            }
            
            CGRect imageRect = CGRectMake(imageXOffset, yOffset, imageWidth, imageHeight);
			
            // Use the image offset and padding to calculate the text offset
            CGFloat textXOffset = imageXOffset + imageWidth + segmentImageTextPadding;
            
            // The text rect's width is the segment width without the image, image padding and insets
            CGRect textRect = CGRectMake(textXOffset, yOffset, [[self.segmentWidthsArray objectAtIndex:idx] floatValue]-imageWidth-segmentImageTextPadding-self.segmentEdgeInset.left-self.segmentEdgeInset.right, stringHeight);
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = textRect;
            titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
            titleLayer.fontSize = self.font.pointSize;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = self.sectionTitles[idx];
            titleLayer.truncationMode = kCATruncationEnd;
			
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = imageRect;
			
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
				titleLayer.foregroundColor = self.selectedTextColor.CGColor;
            } else {
                imageLayer.contents = (id)icon.CGImage;
				titleLayer.foregroundColor = self.textColor.CGColor;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
			titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
			
        }];
    }
    
    if (self.type == HMSegmentedControlTypeCustom) {
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
    }
    // Add the selection indicators
    if (self.selectedSegmentIndex != HMSegmentedControlNoSegment) {
        if (self.selectionStyle == HMSegmentedControlSelectionStyleArrow) {
            if (!self.selectionIndicatorArrowLayer.superlayer) {
                [self setArrowFrame];
                [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
            }
        } else {
            if (!self.selectionIndicatorStripLayer.superlayer) {
                self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
                [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == HMSegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
                    self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
                    [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                }
            }
        }
    }
}

- (void)setArrowFrame {
    self.selectionIndicatorArrowLayer.frame = [self frameForSelectionIndicator];
    
    self.selectionIndicatorArrowLayer.mask = nil;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGPoint p3 = CGPointZero;
    
    if (self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationDown) {
        p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, 0);
        p2 = CGPointMake(0, self.selectionIndicatorArrowLayer.bounds.size.height);
        p3 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, self.selectionIndicatorArrowLayer.bounds.size.height);
    }
    
    if (self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationUp) {
        p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, self.selectionIndicatorArrowLayer.bounds.size.height);
        p2 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, 0);
        p3 = CGPointMake(0, 0);
    }
    
    [arrowPath moveToPoint:p1];
    [arrowPath addLineToPoint:p2];
    [arrowPath addLineToPoint:p3];
    [arrowPath closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.selectionIndicatorArrowLayer.bounds;
    maskLayer.path = arrowPath.CGPath;
    self.selectionIndicatorArrowLayer.mask = maskLayer;
}

- (CGRect)frameForSelectionIndicator {
    CGFloat indicatorYOffset = 0.0f;
    
    if (self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationDown) {
        indicatorYOffset = self.bounds.size.height - self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom;
    }
    
    if (self.selectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationUp) {
        indicatorYOffset = self.selectionIndicatorEdgeInsets.top;
    }
    
    CGFloat sectionWidth = 0.0f;
    
    if (self.type == HMSegmentedControlTypeText) {
        CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedSegmentIndex] textSizeWithFont:self.font].width;
        sectionWidth = stringWidth;
    } else if (self.type == HMSegmentedControlTypeImages) {
        UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
        CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = imageWidth;
    } else if (self.type == HMSegmentedControlTypeTextImages) {
		CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedSegmentIndex] textSizeWithFont:self.font].width;
		UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
		CGFloat imageWidth = sectionImage.size.width;
        if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
            sectionWidth = MAX(stringWidth, imageWidth);
        } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
            sectionWidth = imageWidth + segmentImageTextPadding + stringWidth;
        }
	}
    else if (self.type == HMSegmentedControlTypeCustom)
    {
        UIView *v = self.sectionViews[self.selectedSegmentIndex];
        sectionWidth = v.width;
    }
    
    if (self.selectionStyle == HMSegmentedControlSelectionStyleArrow) {
        CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
        
        CGFloat x = widthToStartOfSelectedIndex + ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) - (self.selectionIndicatorHeight/2);
        return CGRectMake(x, indicatorYOffset, self.selectionIndicatorHeight, self.selectionIndicatorHeight);
    } else {
        if (self.selectionStyle == HMSegmentedControlSelectionStyleTextWidthStripe &&
            sectionWidth <= self.segmentWidth &&
            self.segmentWidthStyle != HMSegmentedControlSegmentWidthStyleDynamic) {
            CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
            CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
            
            CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - sectionWidth / 2);
            if (self.fixIndicatorWidth) {
                return CGRectMake(x + (sectionWidth-self.indicatorWidthForFixed)/2.f, indicatorYOffset, self.indicatorWidthForFixed, self.selectionIndicatorHeight);

            }else{
                return CGRectMake(x + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, sectionWidth - self.selectionIndicatorEdgeInsets.right-self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorHeight);
            }
        } else {
            if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
                CGFloat selectedSegmentOffset = 0.0f;
                CGFloat currentSegmentWidth = [self.segmentWidthsArray[self.selectedSegmentIndex] floatValue];
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (self.selectedSegmentIndex == i){
                        break;
                    }
                    selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
                    i++;
                }
                if (self.fixIndicatorWidth) {
                    return CGRectMake(selectedSegmentOffset +  (currentSegmentWidth-self.indicatorWidthForFixed)/2.f, indicatorYOffset, self.indicatorWidthForFixed, self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom);

                }else{
                    return CGRectMake(selectedSegmentOffset + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] - self.selectionIndicatorEdgeInsets.right-self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom);
                }
            }
            
            if (self.type == HMSegmentedControlTypeCustom && self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
                if ([[self.sectionItems firstObject] isKindOfClass:[NSString class]] || ([[self.sectionItems firstObject] isKindOfClass:[NSDictionary class]] && [[[self.sectionItems firstObject] valueForKey:@"text"] isKindOfClass:[NSString class]])) {
                    NSString *str = [self.sectionItems objectAtIndex:self.selectedSegmentIndex];
                    if ([str isKindOfClass:[NSDictionary class]]) {
                        str = [str valueForKey:@"text"];
                    }
                    CGFloat stringWidth = [str textSizeWithFont:self.font].width;
                    if (stringWidth > self.segmentWidth) {
                        stringWidth = self.segmentWidth - self.selectionIndicatorEdgeInsets.left - self.selectionIndicatorEdgeInsets.right;
                    }
                    
                    if (self.fixIndicatorWidth) {
                        return CGRectMake((self.segmentWidth - self.indicatorWidthForFixed)/2.f + self.selectedSegmentIndex * self.segmentWidth, indicatorYOffset, self.indicatorWidthForFixed, self.selectionIndicatorHeight);

                    }else{
                        return CGRectMake((self.segmentWidth - stringWidth)/2 + self.selectedSegmentIndex * self.segmentWidth, indicatorYOffset, stringWidth, self.selectionIndicatorHeight);
                    }
                }
                CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
                
                if (self.fixIndicatorWidth) {
                    return CGRectMake(widthToStartOfSelectedIndex + (self.segmentWidth-self.indicatorWidthForFixed)/2.f, indicatorYOffset,self.indicatorWidthForFixed, self.selectionIndicatorHeight);

                }else{
                    return CGRectMake(widthToStartOfSelectedIndex + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, self.segmentWidth - self.selectionIndicatorEdgeInsets.left - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
                }
            }
            
            if (self.fixIndicatorWidth) {
                return CGRectMake((self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * self.selectedSegmentIndex, indicatorYOffset,self.indicatorWidthForFixed, self.selectionIndicatorHeight);

            }else{
                return CGRectMake((self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * self.selectedSegmentIndex, indicatorYOffset, self.segmentWidth - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
            }
        }
    }
}

- (CGRect)frameForFillerSelectionIndicator {
    if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat selectedSegmentOffset = 0.0f;
        
        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == i) {
                break;
            }
            selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
            
            i++;
        }
        
        return CGRectMake(selectedSegmentOffset+self.selectionIndicatorBoxLayerInsets.left,(CGRectGetHeight(self.frame)-self.selectionIndicatorBoxLayerHeight)/2.f+self.selectionIndicatorBoxLayerInsets.top, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue]-self.selectionIndicatorBoxLayerInsets.left-self.selectionIndicatorBoxLayerInsets.right, self.selectionIndicatorBoxLayerHeight-self.selectionIndicatorBoxLayerInsets.top-self.selectionIndicatorBoxLayerInsets.bottom);
    }
    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}

- (void)updateSegmentsRects {
    
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    // When `scrollEnabled` is set to YES, segment width will be automatically set to the width of the biggest segment's text or image,
    // otherwise it will be equal to the width of the control's frame divided by the number of segments.
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    
    if (self.type == HMSegmentedControlTypeText && self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
        for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
            CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
    } else if (self.type == HMSegmentedControlTypeText && self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
        NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
        
        for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
            CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
            [mutableSegmentWidths addObject:[NSNumber numberWithFloat:stringWidth]];
        }
        self.segmentWidthsArray = [mutableSegmentWidths copy];
    } else if (self.type == HMSegmentedControlTypeImages) {
        for (UIImage *sectionImage in self.sectionImages) {
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(imageWidth, self.segmentWidth);
        }
    } else if (self.type == HMSegmentedControlTypeTextImages && HMSegmentedControlSegmentWidthStyleFixed){
        //lets just use the title.. we will assume it is wider then images...
        for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
            CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
    } else if (self.type == HMSegmentedControlTypeTextImages && HMSegmentedControlSegmentWidthStyleDynamic) {
        NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
        
        int i = 0;
        for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.right;
#else
            CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.right;
#endif
            UIImage *sectionImage = [self.sectionImages objectAtIndex:i];
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left;
            
            CGFloat combinedWidth = imageWidth + segmentImageTextPadding + stringWidth;
            
            [mutableSegmentWidths addObject:[NSNumber numberWithFloat:combinedWidth]];
            
            i++;
        }
        self.segmentWidthsArray = [mutableSegmentWidths copy];
    }
    else if (self.type == HMSegmentedControlTypeCustom)
    {
        self.segmentWidth = MAX(self.segmentWidth, self.minSegmentWidth);
        for (int i = 0; i < self.sectionViews.count; i++) {
            UIView *v = self.sectionViews[i];
            v.top = 0;
            v.left = i*self.segmentWidth;
            v.width = self.segmentWidth;
            v.height = self.height;
        }
    }

    self.scrollView.scrollEnabled = self.isUserDraggable;
    self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
    
    if (self.alignmentCenter) {
        if (self.scrollView.contentSize.width < self.frame.size.width) {
            self.scrollView.frame = CGRectMake(self.frame.size.width/2.f-self.scrollView.contentSize.width/2.f, 0, self.scrollView.contentSize.width, self.scrollView.frame.size.height);
        }
    }
}

- (NSUInteger)sectionCount {
    if (self.type == HMSegmentedControlTypeText) {
        return self.sectionTitles.count;
    } else if (self.type == HMSegmentedControlTypeImages ||
               self.type == HMSegmentedControlTypeTextImages) {
        return self.sectionImages.count;
    }
    else if (self.type == HMSegmentedControlTypeCustom)
        return self.sectionItems.count;
    
    return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    if (self.sectionTitles || self.sectionImages) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = 0;
        if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
            // To know which segment the user touched, we need to loop over the widths and substract it from the x position.
            if (self.alignmentCenter) {            
                touchLocation = [touch locationInView:self.scrollView];
            }
            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
            for (NSNumber *width in self.segmentWidthsArray) {
                widthLeft = widthLeft - [width floatValue];
                
                // When we don't have any width left to substract, we have the segment index.
                if (widthLeft <= 0)
                    break;
                
                segment++;
            }
        }
        if (self.shouldSelectedSegmentAtIndexBlock) {
            if (!self.shouldSelectedSegmentAtIndexBlock(segment)) {
                return;
            }
        }
        NSUInteger sectionsCount = 0;
        
        if (self.type == HMSegmentedControlTypeImages) {
            sectionsCount = [self.sectionImages count];
        } else if (self.type == HMSegmentedControlTypeTextImages || self.type == HMSegmentedControlTypeText) {
            sectionsCount = [self.sectionTitles count];
        }
        else if (self.type == HMSegmentedControlTypeCustom)
            sectionsCount = self.sectionItems.count;
        
        if (segment >= 0 && segment < sectionsCount)
        {
            if (self.isTouchEnabled)
                if (self.tapAtIndexBlock)
                    self.tapAtIndexBlock(segment);
        }
        if (segment != self.selectedSegmentIndex && segment < sectionsCount) {
            // Check if we have to do anything with the touch event
            if (self.isTouchEnabled)
                [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }
    }
}

#pragma mark - Scrolling

- (CGFloat)totalSegmentedControlWidth {
    if (self.type == HMSegmentedControlTypeText && self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
        return self.sectionTitles.count * self.segmentWidth;
    } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
        return [[self.segmentWidthsArray valueForKeyPath:@"@sum.self"] floatValue];
    } else if (self.type == HMSegmentedControlTypeCustom){
        return self.sectionViews.count * self.segmentWidth;
    } else {
        return self.sectionImages.count * self.segmentWidth;
    }
}

- (void)scrollToSelectedSegmentIndex {
    CGRect rectForSelectedIndex;
    CGFloat selectedSegmentOffset = 0;
    if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
        rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                          0,
                                          self.segmentWidth,
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
        NSInteger i = 0;
        CGFloat offsetter = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == i)
                break;
            offsetter = offsetter + [width floatValue];
            i++;
        }
        
        rectForSelectedIndex = CGRectMake(offsetter,
                                          0,
                                          [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue],
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - ([[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] / 2);
    }
    
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:YES];
}

#pragma mark - Index change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
    if (self.selectedStyleBlock) {
        self.selectedStyleBlock(self.customViews, index);
    }
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];
    
    if (index == HMSegmentedControlNoSegment) {
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        [self scrollToSelectedSegmentIndex];
        
        if (animated) {
            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new
            // segment index without animating.
            if(self.selectionStyle == HMSegmentedControlSelectionStyleArrow) {
                if ([self.selectionIndicatorArrowLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }else {
                if ([self.selectionIndicatorStripLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                    
                    if (self.selectionStyle == HMSegmentedControlSelectionStyleBox && [self.selectionIndicatorBoxLayer superlayer] == nil)
                        [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
            
            // Restore CALayer animations
            self.selectionIndicatorArrowLayer.actions = nil;
            self.selectionIndicatorStripLayer.actions = nil;
            self.selectionIndicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [self setArrowFrame];
            self.selectionIndicatorBoxLayer.frame = [self frameForSelectionIndicator];
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectionIndicatorArrowLayer.actions = newActions;
            [self setArrowFrame];
            
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
        }
    }
    
    if (self.selectedStyleBlock) {
        self.selectedStyleBlock(self.customViews, index);
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

- (void)setSelectedStyleBlock:(HMSelectedStyleBlcok)selectedStyleBlock {
    _selectedStyleBlock = selectedStyleBlock;
    if (selectedStyleBlock) {
        selectedStyleBlock(self.customViews, self.selectedSegmentIndex);
        [self setNeedsLayout];
    }
}

- (NSArray *)customViews
{
    return self.sectionViews;
}

@end
