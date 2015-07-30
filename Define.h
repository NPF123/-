//
//  Define.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#ifndef NurseryRhyme_Define_h
#define NurseryRhyme_Define_h


#define kSreenSize [UIScreen mainScreen].bounds.size

//推荐
#define kTujian @"http://e.dangdang.com/media/api.go?action=column&columnType=%@&start=%ld&end=%ld&channelType=all"
#define tWeini @"ts_children_girl"
#define tMeiri @"ts_children_boy"
#define tShuiqian @"ts_children_selected"
#define tZuiai @"ts_children_rob"

//365夜故事
#define kGGT @"http://e.dangdang.com/media/api.go?action=block&code=ts_children_advertisement"
//轮播图
#define kLBT @"http://e.dangdang.com/media/api.go?action=block&code=ts_children_focus"

/*
 #define kWnTuijian @"http://e.dangdang.com/media/api.go?action=column&columnType=ts_children_girl&start=0&end=2&channelType=all"//为你推荐：
 #define kMrjingxuan @"http://e.dangdang.com/media/api.go?action=column&columnType=ts_children_boy&start=0&end=2&channelType=all"//每日精选：
 
 #define kSqGushi @"http://e.dangdang.com/media/api.go?action=column&columnType=ts_children_selected&start=0&end=2&channelType=all"//睡前故事：
 
 #define KBbZuiai @"http://e.dangdang.com/media/api.go?action=column&columnType=ts_children_rob&start=0&end=2&channelType=all"//宝宝最爱：
 */



// 榜单
#define kBangdan @"http://e.dangdang.com/media/api3.go?action=mediaRankingList&listType=%@&channelType=all&start=%ld&end=%ld"
#define bReting @"bbts_play"
#define bXiazai @"bbts_download"
#define bResou @"bbts_search"

/*#define kRtBang @"http://e.dangdang.com/media/api3.go?action=mediaRankingList&listType=bbts_play&channelType=all&start=0&end=4" //热听榜:
 
 #define kXzBang @"http://e.dangdang.com/media/api3.go?action=mediaRankingList&listType=bbts_download&channelType=all&start=0&end=4"//下载榜：
 
 #define kRsBang @"http://e.dangdang.com/media/api3.go?action=mediaRankingList&listType=bbts_search&channelType=all&start=0&end=4"//热搜榜：
 */


//分类
#define  kCategory  @"http://e.dangdang.com/media/api3.go?action=mediaCategory&channelType=bbts&start=%ld&end=%ld&data=1"

//#define  kCategory  @"http://e.dangdang.com/media/api3.go?action=mediaCategory&channelType=bbts&start=0&end=4&data=1"

#define kFeilei @"http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=%@&dimension=%@&start=%ld&end=%ld&returnType=json"
//最热 最新
#define fPlay @"play"
#define fUpdate @"update"

#define fETJY @"ETJY"//儿童教育
#define fYZQM @"YZQM"//益智启蒙
#define fKPBK @"KPBK"//科普百科
#define fGXJD @"GXJD"//国学经典
#define fYYGS @"YYGS"//寓言故事
#define fTSS @"TSS"  //童诗
#define fKHGS @"KHGS"//童话故事
#define fEG @"EG"    //儿歌

#define kShouCang @"ShouCang"
#define kJilv @"Jilv"
#define kZhong @"zhong"
#define kYiXia @"yixia"
#define kIsWIFI @"isWIFI"
#define kIsAUTO @"isAUTO"
#define  kPath [[NSBundle mainBundle] pathForResource:@"Stutic" ofType:@"plist"]
#define kFirst @"first"
#define kTimer @"Timer"
/*儿童教育：
 最热： http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=ETJY&dimension=play&start=0&end=20&returnType=json
 
 最新：	http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=ETJY&dimension=update&start=0&end=20&returnType=json
 
 益智启蒙：
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=YZQM&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=YZQM&dimension=update&start=0&end=20&returnType=json
 
 科普百科：
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=KPBK&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=KPBK&dimension=update&start=0&end=20&returnType=json
 
 国学经典：
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=GXJD&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=GXJD&dimension=update&start=0&end=20&returnType=json
 寓言故事：
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=YYGS&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=YYGS&dimension=update&start=0&end=20&returnType=json
 
 童诗：
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=TSS&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=TSS&dimension=update&start=0&end=20&returnType=json
 童话故事：
 
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=THGS&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=THGS&dimension=update&start=0&end=20&returnType=json
 
 儿歌：
 
	最热：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=EG&dimension=play&start=0&end=20&returnType=json
	最新：http://e.dangdang.com/media/api3.go?action=mediaCategoryLeaf&category=EG&dimension=update&start=0&end=20&returnType=json
 
 
 */
//微博反馈
#define kFaikui @"http://weibo.com/u/5059663581/home"

#define kZuiqi @"http://e.dangdang.com/media/api3.go?action=getMediasBySaleId&saleId=%@&returnType=json&platformSource=BBTS-P"//专辑详情：
//试听  音乐播放器的界面
#define kShiting @"http://e.dangdang.com/media/api3.go?action=getAllChapterByMediaIdForListen&start=%ld&end=%ld&mediaId=%@&returnType=json"//试听详情：

//搜索结果
#define kSearchResult @"http://e.dangdang.com/media/api3.go?action=search&searchContent=%@&start=%ld&end=%ld&returnType=json&platformSource=BBTS-P"
//搜素列表
#define kSearchList @"http://e.dangdang.com/media/api3.go?action=searchAssociate&searchContent=%@&returnType=json&platformSource=BBTS-P"

#endif
