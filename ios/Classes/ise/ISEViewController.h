//
//  ISEViewController.h
//  MSCDemo_UI
//
//  Created by 张剑 on 15/1/15.
//
//

/* updated by xyzhang 2021/6/1
 语音评测（普通版）已下线，老用户请查看语音评测（普通版：https://www.xfyun.cn/doc/voiceservice/ise/iOS-SDK.html） ，并请老用户尽快迁移至语音评测（流式版），迁移方式如下：
 需指定参数，中文：sub=ise,ent=cn_vip,plev=0，英文：sub=ise,ent=en_vip,plev=0，详见参数说明：https://www.xfyun.cn/doc/Ise/iOS-SDK.html#_1-评测
 */

#import <UIKit/UIKit.h>

@class ISEParams;

/**
 demo of Speech Evaluation (ISE)
 **/
@interface ISEViewController : UIViewController

@property (nonatomic, strong) ISEParams *iseParams;

@end
