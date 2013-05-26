//
//  AEDCGHelpers.h
//  aerocopy-ios
//
//  Created by Johan Halin on 3.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGRect AEDCGRectPlace(CGRect rect, CGFloat x, CGFloat y)
{
	return CGRectMake(x, y, rect.size.width, rect.size.height);
}

static CGRect AEDCGRectPlaceX(CGRect rect, CGFloat x)
{
	return AEDCGRectPlace(rect, x, rect.origin.y);
}

static CGRect AEDCGRectPlaceY(CGRect rect, CGFloat y)
{
	return AEDCGRectPlace(rect, rect.origin.x, y);
}

static CGRect AEDCGRectWithSize(CGRect rect, CGFloat width, CGFloat height)
{
	return CGRectMake(rect.origin.x, rect.origin.y, width, height);
}

static CGRect AEDCGRectWithWidth(CGRect rect, CGFloat width)
{
	return AEDCGRectWithSize(rect, width, rect.size.height);
}

static CGRect AEDCGRectWithHeight(CGRect rect, CGFloat height)
{
	return AEDCGRectWithSize(rect, rect.size.width, height);
}
