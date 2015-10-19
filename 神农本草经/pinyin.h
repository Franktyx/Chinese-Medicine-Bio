//
//  pinyin.h
//  神农本草经
//
//  Created by Yuxiang Tang on 9/17/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */

char pinyinFirstLetter(unsigned short hanzi);
