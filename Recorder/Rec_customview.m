#import "Rec_customview.h"

@implementation Rec_customview
{
    int width_line;
    CGContextRef context,context_2;
    UIView *cust_view_2;
}
@synthesize h,w;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    if (context)
    {
        context=Nil;
    }
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width_line);
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(150,87,70,70));
    CGContextStrokePath(context);
}
- (void)setZeroPointValue:(int)value{
   width_line =value;
}


@end
