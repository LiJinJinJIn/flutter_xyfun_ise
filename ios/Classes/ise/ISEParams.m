//
//  ISEParams.m
//  MSCDemo_UI
//
//  Created by 张剑 on 15/2/5.
//
//

#import "ISEParams.h"
#import "IFlyMSC/IFlyMSC.h"


#pragma mark - consts for key stored

#pragma mark - const values

NSString* const KCLanguageZHCN=@"zh_cn";
NSString* const KCLanguageENUS=@"en_us";

NSString* const KCCategorySentence=@"read_sentence";
NSString* const KCCategoryWord=@"read_word";
NSString* const KCCategorySyllable=@"read_syllable";
// ---- update ise_flow 2021.06.01 ---- start
NSString* const KCCategoryChapter=@"read_chapter";
NSString* const KCCategoryExpression=@"simple_expression";
NSString* const KCCategoryChoice=@"read_choice";
NSString* const KCCategoryTopic=@"topic";
NSString* const KCCategoryRetell=@"retell";
NSString* const KCCategoryPictureTalk=@"picture_talk";
NSString* const KCCategoryOralTranslation=@"oral_translation";
// ---- update ise_flow 2021.06.01 ---- end

NSString* const KCRstLevelPlain=@"plain";
NSString* const KCRstLevelComplete=@"complete";

NSString* const KCBOSDefault=@"5000";
NSString* const KCEOSDefault=@"1800";
NSString* const KCTimeoutDefault=@"-1";

NSString* const KCIseDictionaryKey=@"ISEParams";

NSString* const KCLanguage=@"language";
NSString* const KCLanguageShow=@"languageShow";
NSString* const KCCategory=@"category";
NSString* const KCCategoryShow=@"categoryShow";
NSString* const KCRstLevel=@"rstLevel";
NSString* const KCBOS=@"bos";
NSString* const KCEOS=@"eos";
NSString* const KCTimeout=@"timeout";

NSString* const KCSourceType=@"audio_source";
NSString* const KCSourceMIC=@"1";
NSString* const KCSourceSTREAM=@"-1";

#pragma mark -

@implementation ISEParams

- (NSString *)toString {
    
    NSString *strIseParams = [[NSString alloc] init] ;
    
    if (self.language && [self.language length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant LANGUAGE], self.language];
    }

    if (self.category && [self.category length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant ISE_CATEGORY], self.category];
    }
    if (self.rstLevel && [self.rstLevel length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant ISE_RESULT_LEVEL], self.rstLevel];
    }

    if (self.bos && [self.bos length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant VAD_BOS], self.bos];
    }

    if (self.eos && [self.eos length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant VAD_EOS], self.eos];
    }

    if (self.timeout && [self.timeout length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant SPEECH_TIMEOUT], self.timeout];
    }
    
    if (self.audioSource && [self.audioSource length] > 0) {
        strIseParams = [strIseParams stringByAppendingFormat:@",%@=%@", [IFlySpeechConstant AUDIO_SOURCE], self.audioSource];
    }


    return strIseParams;
}

- (void)setDefaultParams{
    
    self.language=KCLanguageZHCN;
    self.languageShow= @"K_LangCHZN";
    self.category=KCCategorySentence;
    self.categoryShow= @"K_ISE_CateSent";
    self.rstLevel=KCRstLevelComplete;
    self.bos=KCBOSDefault;
    self.eos=KCEOSDefault;
    self.timeout=KCTimeoutDefault;
    self.audioSource=KCSourceMIC;
}

#pragma mark - consts for key stored

- (void)toUserDefaults{
    NSMutableDictionary* paramsDic=[NSMutableDictionary dictionaryWithCapacity:8];
    if(paramsDic){
        if(self.language){
            [paramsDic setObject:self.language forKey:KCLanguage];
        }
        if(self.languageShow){
            [paramsDic setObject:self.languageShow forKey:KCLanguageShow];
        }
        if(self.category){
             [paramsDic setObject:self.category forKey:KCCategory];
        }
        if(self.categoryShow){
             [paramsDic setObject:self.categoryShow forKey:KCCategoryShow];
        }
        if(self.rstLevel){
             [paramsDic setObject:self.rstLevel forKey:KCRstLevel];
        }
        if(self.bos){
             [paramsDic setObject:self.bos forKey:KCBOS];
        }
        if(self.eos){
             [paramsDic setObject:self.eos forKey:KCEOS];
        }
        if(self.timeout){
             [paramsDic setObject:self.timeout forKey:KCTimeout];
        }
        if(self.audioSource){
            [paramsDic setObject:self.audioSource forKey:KCSourceType];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:paramsDic forKey:KCIseDictionaryKey];
}

+ (ISEParams *)fromUserDefaults{
    ISEParams* params=[[ISEParams alloc] init];
    [params setDefaultParams];
    NSDictionary *paramsDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KCIseDictionaryKey];
    if(paramsDic){
        params.language=[paramsDic objectForKey:KCLanguage];
        params.languageShow=[paramsDic objectForKey:KCLanguageShow];
        params.category=[paramsDic objectForKey:KCCategory];
        params.categoryShow=[paramsDic objectForKey:KCCategoryShow];
        params.rstLevel=[paramsDic objectForKey:KCRstLevel];
        params.bos=[paramsDic objectForKey:KCBOS];
        params.eos=[paramsDic objectForKey:KCEOS];
        params.timeout=[paramsDic objectForKey:KCTimeout];
        params.audioSource=[paramsDic objectForKey:KCSourceType];
    }
    return params;
}

@end
