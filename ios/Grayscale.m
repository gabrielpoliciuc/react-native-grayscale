#import "Grayscale.h"
#import <UIKit/UIKit.h>

@implementation Grayscale

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(toGrayscale:(NSString *)base64 callback:(RCTResponseSenderBlock)callback)
{
    @try {
        if ([base64 hasPrefix:@"data:image/"] == NO) {
            base64 = [@"data:image/png;base64," stringByAppendingString:base64];
        }
        NSURL *url = [NSURL URLWithString:base64];
        NSData *originalImageData = [NSData dataWithContentsOfURL:url];
        UIImage *originalImage = [UIImage imageWithData:originalImageData];
        UIImage* grayscaleImage = [self convertImageToGrayscale: originalImage];
        NSString* base64Grayscale = [UIImagePNGRepresentation(grayscaleImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        callback(@[base64Grayscale]);
    }
    @catch(NSException* exception) {
        callback(@[@""]);
    }
}

- (UIImage *)convertImageToGrayscale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if (imageRef) {
        CFRelease(imageRef);
    }
    
    // Return the new grayscale image
    return newImage;
}


@end
