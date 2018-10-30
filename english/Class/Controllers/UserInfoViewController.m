//
//  UserInfoViewController.m
//  english
//
//  Created by zhangkai on 2018/10/13.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ModifyFieldViewController.h"
#import "BRPickerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) IBOutlet UIView *avatarItemView;
@property (nonatomic, assign) IBOutlet UIView *gradeItemView;
@property (nonatomic, assign) IBOutlet UIView *phoneItemView;
@property (nonatomic, assign) IBOutlet UIView *passwordItemView;

@property (nonatomic, assign) IBOutlet UILabel *gradeLbl;
@property (nonatomic, assign) IBOutlet UILabel *schollLbl;
@property (nonatomic, assign) IBOutlet UILabel *usernameLbl;
@property (nonatomic, assign) IBOutlet UILabel *phoneLbl;

@property (nonatomic, assign) IBOutlet UIImageView *avatarImageView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logined:)
                                                 name:kNotiLoginSuccess
                                               object:nil];
    
    [self logined:nil];
}

- (void)logined:(NSNotification *)notify {
    if(mAppDelegate._userInfo) {
        self.usernameLbl.text = mAppDelegate._userInfo[@"nick_name"];
        self.gradeLbl.text = [[CacheHelper shareInstance] getGrade];
        NSString *phone = mAppDelegate._userInfo[@"mobile"];
        NSRange range = NSMakeRange(3, 5);
        self.phoneLbl.text = [phone stringByReplacingCharactersInRange:range withString:@"*****"];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:mAppDelegate._userInfo[@"face"]]
                                placeholderImage:[UIImage imageNamed:@"default_big_avatar"]];
        self.schollLbl.text = mAppDelegate._userInfo[@"school"];
        self.schollLbl.textColor = [UIColor lightGrayColor];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.avatarItemView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.avatarItemView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.gradeItemView.bounds
                                                   byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.path = maskPath2.CGPath;
    self.gradeItemView.layer.mask = maskLayer2;
    
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.phoneItemView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer3 = [[CAShapeLayer alloc] init];
    maskLayer3.path = maskPath3.CGPath;
    self.phoneItemView.layer.mask = maskLayer3;
    
    UIBezierPath *maskPath4 = [UIBezierPath bezierPathWithRoundedRect:self.passwordItemView.bounds
                                                    byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                          cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer4 = [[CAShapeLayer alloc] init];
    maskLayer4.path = maskPath4.CGPath;
    self.passwordItemView.layer.mask = maskLayer4;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    if([segue.identifier isEqualToString:@"modifyField"]){
        ModifyFieldViewController *modifyFieldViewController = (ModifyFieldViewController *)segue.destinationViewController;
        modifyFieldViewController.info = sender;
    }
}

- (IBAction)nav2field:(id)sender {
    [self performSegueWithIdentifier:@"modifyField" sender:@{
                                                             @"title": @"修改姓名",
                                                             @"type": @"0"
                                                             }];
}

- (IBAction)nav2field2:(id)sender {
    [self performSegueWithIdentifier:@"modifyField" sender:@{
                                                             @"title": @"修改学校",
                                                             @"type": @"1"
                                                             }];
}

- (IBAction)modifyGrade:(id)sender {
    NSArray *dataSource = @[@"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级"];
    __weak typeof(self) weakSelf = self;
    
    NSString *grade = [[CacheHelper shareInstance] getGrade];
    [BRStringPickerView showStringPickerWithTitle:@"年级" dataSource:dataSource defaultSelValue:grade isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
        [[CacheHelper shareInstance] setGrade:selectValue];
        weakSelf.gradeLbl.text = selectValue;
    } cancelBlock:^{
        
    }];
}

- (IBAction)modifyAvatar:(id)sender {
    [self chooseImage];
}

- (void)chooseImage {
    UIAlertController* sheetController = [UIAlertController
                                          alertControllerWithTitle:@"选择"
                                          message:@""
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction* item = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf selectImageWithType:UIImagePickerControllerSourceTypeCamera];
        }];
        [sheetController addAction:item];
    }
    
    UIAlertAction* item2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf selectImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [sheetController addAction:item2];
    
    [sheetController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [self.navigationController.tabBarController presentViewController:sheetController animated:YES completion:nil];
}

- (void)selectImageWithType: (UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    [self.navigationController.tabBarController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)uploadImage: (NSString *)data {
    __weak typeof(self) weakSelf = self;
    [self show:@"上传中..."];
    NSDictionary *params = @{
               @"user_id": mAppDelegate._userInfo[@"id"],
               @"face": data,
               @"nick_name": @"",
               @"school": @""
               };
    [NetUtils postWithUrl:UPD_URL params:params callback:^(NSDictionary *data) {
        [weakSelf dismiss];
        if([data[@"code"] integerValue] == 1){
            [weakSelf alert:@"修改成功" callback:^{
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:mAppDelegate._userInfo];
                userInfo[@"face"] = data[@"data"][@"face"];
                mAppDelegate._userInfo = userInfo;
                [[CacheHelper shareInstance] setCurrentUser:userInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLoginSuccess object:nil];
                [weakSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:mAppDelegate._userInfo[@"face"]]
                                        placeholderImage:[UIImage imageNamed:@"default_big_avatar"]];
            }];
        } else {
            [weakSelf alert:data[@"msg"]];
        }
    } error:nil reqencryt:NO iszip:YES resencryt:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
     __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
                                   [weakSelf uploadImage: [weakSelf image2DataURL:image]];
                               }];
}


- (BOOL)imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


- (NSString *)image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.8f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
