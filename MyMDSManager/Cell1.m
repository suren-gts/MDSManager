
#import "Cell1.h"

@implementation Cell1
@synthesize titleLabel,arrowImageView;

- (void)dealloc
{
    self.titleLabel = nil;
  //  self.arrowImageView = nil;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"icn_collapse.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"icn_expand.png"];
    }
}

@end
