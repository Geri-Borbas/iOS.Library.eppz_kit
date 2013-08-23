//
//  EPPZPagingScrollViewController.m
//  eppz!kit
//
//  Created by Borbás Geri on 7/23/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZPagingScrollViewController.h"

@implementation EPPZPagingScrollViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    self.pageControl.numberOfPages = round(self.contentView.bounds.size.width / self.scrollView.bounds.size.width);
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageControlVaueChanged:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - Paging

-(void)pageControlVaueChanged:(UIPageControl*) pageControl
{    
    //Adjust scrollView.
    float offset = pageControl.currentPage * self.scrollView.bounds.size.width;
    CGPoint contentOffset = CGPointMake(offset, 0.0);
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Calculate.
    int pageNumber = ceil((scrollView.contentOffset.x - (scrollView.bounds.size.width / 2)) / scrollView.bounds.size.width);
    
    //Adjust pageControl.
    if (self.pageControl.currentPage != pageNumber)
    { self.pageControl.currentPage = pageNumber; }
}

-(void)scrollToPage:(int) pageNumber animated:(BOOL) animated
{    
    //Adjust scrollView.
    float offset = pageNumber * self.scrollView.bounds.size.width;
    CGPoint contentOffset = CGPointMake(offset, 0.0);
    [self.scrollView setContentOffset:contentOffset animated:animated];
}


@end
