//
//  Header.h
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define RedColor RGB(212, 61, 61)

#define GrayColor RGB(34, 34, 34)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif /* Header_h */
