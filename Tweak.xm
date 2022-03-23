// Developer By Azozz ALFiras
// github : https://github.com/AzozzALFiras
// Twitter : https://twitter.com/AzozzALFiras

#import <UIKit/UIKit.h>

@interface IGImageURL
-(CGFloat)width;
-(CGFloat)height;
-(NSURL*)url;
@end

@interface IGPhoto
{
NSArray *_originalImageVersions;
}
@end

@interface IGVideo
{
NSArray *_videoVersionDictionaries;
}
@end


@interface IGMedia{
	NSInteger _mediaType;
}

-(id)photo;
-(id)video;
@end

@interface IGFeedItemPhotoCell{
IGMedia *_post;
}
@end

@interface IGModernFeedVideoCell
-(id)delegate;
@end

@interface IGFeedSectionController
-(id)media;
@end

@interface IGFeedItemUFICell
-(id)delegate;
@property (strong) UIButton * AFSocialActionButton;

@end

@interface IGSundialViewerVerticalUFI
-(id)delegate;
@end

@interface IGSundialViewerControlsOverlayView
-(id)video;
@end

@interface IGSundialViewerVideoCell
-(id)video;
@end

@interface IGSundialVideoPlaybackView : UIView{
IGVideo *_video;
}
@end





%hook IGFeedItemPhotoCell
-(void)feedPhotoDidDoubleTapToLike:(id)arg2 locationInfo:(id)info{

IGMedia *post = MSHookIvar<IGMedia*>(self,"_post");
IGPhoto *photo = [post photo];
NSArray *array = MSHookIvar<NSArray*>(photo,"_originalImageVersions");

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick your quality:"
message:nil
preferredStyle:UIAlertControllerStyleActionSheet];
for (int i = 0 ; i < array.count; i++){

IGImageURL *imageURL = array[i];
CGFloat width = [imageURL width];
CGFloat height = [imageURL height];

NSString * qualityString = [NSString stringWithFormat:@"%.0fx%.0f",height,width];

NSString *titleString = qualityString;
UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
NSLog(@"Selected Value: %@",array[i]);

NSURL *urlToDownload = [imageURL url];
NSData *data = [NSData dataWithContentsOfURL:urlToDownload];
UIImage *img = [[UIImage alloc] initWithData:data];
UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);

UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Instasave"
message:@"Photo Saved!"
preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {}];

[alert addAction:defaultAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}];
[alertController addAction:action];
}
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
style:UIAlertActionStyleCancel
handler:^(UIAlertAction *action) {
}];
[alertController addAction:cancelAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

}
%end

%hook IGModernFeedVideoCell
-(void)videoPlayerOverlayControllerDidDoubleTap:(id)arg1{

//if you are hooking and want to add the code from IGFeedItemUFICell you can use the -(id)delegate method to get an instance of IGFeedSectionController

//For Example:

/*
%hook IGFeedItemUFICell
-(void)didClickSaveButton{

id delegate = [self delegate];
then continue the code below:
*/

id sectionController = [self delegate];
id media = [sectionController media];
id video = [media video];
NSArray *myArr = MSHookIvar<NSArray*>(video,"_videoVersionDictionaries");

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick your quality:"
message:nil
preferredStyle:UIAlertControllerStyleActionSheet];
for (int i = 0; i < myArr.count; i++){

NSDictionary *dict = myArr[i];
NSString *width = [dict objectForKey:@"width"];
NSString *height = [dict objectForKey:@"height"];
NSString *URLString = [dict objectForKey:@"url"];
NSURL *URL = [NSURL URLWithString:URLString];

NSString * qualityString = [NSString stringWithFormat:@"%@ x %@",height,width];

NSString *titleString = qualityString;
UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
NSLog(@"Selected Value: %@",myArr[i]);

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
NSData *urlData = [NSData dataWithContentsOfURL:URL];
if ( urlData )
{
NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString  *documentsDirectory = [paths objectAtIndex:0];

NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];

dispatch_async(dispatch_get_main_queue(), ^{
[urlData writeToFile:filePath atomically:YES];
UISaveVideoAtPathToSavedPhotosAlbum(filePath,nil,nil,nil);
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Instasave"
message:@"Video Saved!"
preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {}];

[alert addAction:defaultAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
});
}

});


}];
[alertController addAction:action];
}
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
style:UIAlertActionStyleCancel
handler:^(UIAlertAction *action) {
}];
[alertController addAction:cancelAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
%end

%hook IGSundialVideoPlaybackView
%property (strong) UIButton * AFSocialButtonStory;
- (void)layoutSubviews{
%orig;
UIView* oldBt = [self viewWithTag:482];
if(oldBt) {
[oldBt removeFromSuperview];
}
self.AFSocialButtonStory = [UIButton buttonWithType:UIButtonTypeContactAdd];
self.AFSocialButtonStory.tag = 482;
[self.AFSocialButtonStory addTarget:self action:@selector(AFSocialSaveStoires) forControlEvents:UIControlEventTouchUpInside];
[self.AFSocialButtonStory setImage:[UIImage imageNamed:@InstaDownload] forState:UIControlStateNormal];
@try {
[self.AFSocialButtonStory setTintColor:[UIColor labelColor]];
}@catch(NSException*e){
}
self.AFSocialButtonStory.frame = CGRectMake(0, 0, 40, 40);
self.AFSocialButtonStory.center = self.center;

float coordXFactor = 2.6f;
@try {
if(self.delegate && [self.delegate respondsToSelector:@selector(currentStoryItem)]) {
coordXFactor = 3.6f;
}
}@catch(NSException*e){
}
self.AFSocialButtonStory.frame = CGRectMake(self.AFSocialButtonStory.frame.origin.x+(self.frame.size.width/coordXFactor), -4, self.AFSocialButtonStory.frame.size.width, self.AFSocialButtonStory.frame.size.height);
[self addSubview:self.AFSocialButtonStory];

}
%new
- (void)AFSocialSaveStoires{
}
-(void)gestureController:(id)controller didObserveLongPressBegin:(id)arg1{

IGVideo *vid = MSHookIvar<IGVideo*>(self,"_video");
NSArray *myArr = MSHookIvar<NSArray*>(vid,"_videoVersionDictionaries");

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick your quality:"
message:nil
preferredStyle:UIAlertControllerStyleActionSheet];
for (int i = 0; i < myArr.count; i++){

NSDictionary *dict = myArr[i];
NSString *width = [dict objectForKey:@"width"];
NSString *height = [dict objectForKey:@"height"];
NSString *URLString = [dict objectForKey:@"url"];
NSURL *URL = [NSURL URLWithString:URLString];

NSString * qualityString = [NSString stringWithFormat:@"%@ x %@",height,width];

NSString *titleString = qualityString;
UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
NSLog(@"Selected Value: %@",myArr[i]);

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
NSData *urlData = [NSData dataWithContentsOfURL:URL];
if ( urlData )
{
NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString  *documentsDirectory = [paths objectAtIndex:0];

NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];

dispatch_async(dispatch_get_main_queue(), ^{
[urlData writeToFile:filePath atomically:YES];
UISaveVideoAtPathToSavedPhotosAlbum(filePath,nil,nil,nil);
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Instasave"
message:@"Video Saved!"
preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {}];

[alert addAction:defaultAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
});
}

});


}];
[alertController addAction:action];
}
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
style:UIAlertActionStyleCancel
handler:^(UIAlertAction *action) {
}];
[alertController addAction:cancelAction];
[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
%end
