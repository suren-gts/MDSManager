
#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell


@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;
@property (nonatomic,retain)IBOutlet UIImageView *imgIcon;
@property(strong,nonatomic)IBOutlet UIImageView * imgArrow;


- (void)changeArrowWithUp:(BOOL)up;
@end
