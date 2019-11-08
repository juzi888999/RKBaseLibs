//
//  RKWaterFlowLayout.m
//  RKBaseLibs
//
//  Created by rk on 2017/12/21.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "RKWaterFlowLayout.h"
#import <objc/message.h>

@interface RKWaterFlowLayout ()

@property NSMutableArray<NSNumber *> *bottoms;//记录各列最大值
@property NSMutableDictionary *frameDictionary;//记录历史cell的位置，key为indexPath

@end

static CGFloat itemPadding = 10;
@implementation RKWaterFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frameDictionary = [NSMutableDictionary dictionary];
        self.bottoms = [NSMutableArray array];
        self.section = 0;
        self.numberOfColumns = 1;
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = itemPadding;
        self.minimumLineSpacing = itemPadding;
        self.sectionInset = UIEdgeInsetsMake(itemPadding, itemPadding, itemPadding, itemPadding);
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    NSAssert(numberOfColumns!=0, nil);
    
    _numberOfColumns = numberOfColumns;
    [self resetBottoms];
}

- (void)clearFrameCache
{
    [self resetBottoms];
    [self.frameDictionary removeAllObjects];
    
    [self.collectionView reloadData];
}

- (void)resetBottoms
{
    [self.bottoms removeAllObjects];
    for (NSInteger i=0; i<self.numberOfColumns; i++) {
        self.bottoms[i] = @(self.sectionInset.top);
    }
}

#pragma mark - overwrite
- (CGSize)collectionViewContentSize
{
    __block CGFloat height = 0;
    [self getMaxBottomCompletion:^(CGFloat maxY, NSInteger column) {
        height = maxY;
    }];
    return CGSizeMake(self.collectionView.frame.size.width, height+self.sectionInset.bottom);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes   layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
    layoutHeader.frame = CGRectMake(0, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
    [array addObject:layoutHeader];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:self.section];
    for (NSInteger i=0; i<itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:self.section]];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [array addObject:attributes];
        }
    }
    
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = [self itemFrameAtIndexPath:indexPath];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    //scrollview bounds wil change when scrolling: http://objccn.io/issue-3-2/
    BOOL invalidate = self.collectionView.bounds.size.width != newBounds.size.width;
    if (invalidate) {
        [self invalidateOldFrames];
    }
    return invalidate;
}

#pragma mark - private
- (void)invalidateOldFrames
{
    for (NSInteger i=0; i<self.numberOfColumns; i++) {
        self.bottoms[i] = @(self.sectionInset.top);
    }
    [self.frameDictionary removeAllObjects];
}

- (CGRect)randomBoundsAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
//        CGSize itemSize = ((CGSize (*)(id, SEL, UICollectionView *, UICollectionViewFlowLayout *, NSIndexPath *))objc_msgSend)(self.collectionView.delegate, @selector(collectionView:layout:sizeForItemAtIndexPath:) , self.collectionView, self, indexPath);
//        return   (CGRect){.size = itemSize};
//    }else{
//        CGFloat width = (self.collectionView.frame.size.width-self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing*(self.numberOfColumns - 1))/self.numberOfColumns;
//        return CGRectMake(0, 0, width, MAX(arc4random()*1.0/INT32_MAX*200, 80));
//    }
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self;
        CGSize itemSize = CGSizeZero;
        if (indexPath.row == 0) {
            itemSize = CGSizeMake(layout.itemSize.width*2+layout.minimumInteritemSpacing, layout.itemSize.height*2+layout.minimumLineSpacing);
        }else{        
            itemSize = CGSizeMake(layout.itemSize.width, layout.itemSize.height);
        }
        return   (CGRect){.size = itemSize};
        
    }else{
        CGFloat width = (self.collectionView.frame.size.width-self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing*(self.numberOfColumns - 1))/self.numberOfColumns;
        return CGRectMake(0, 0, width, MAX(arc4random()*1.0/INT32_MAX*200, 80));
    }
}

- (NSString *)frameKeyAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%li_%li", (long)indexPath.section, (long)indexPath.row];
}

- (void)getMaxBottomCompletion:(void(^)(CGFloat minY, NSInteger column))completion
{
    CGFloat minY = self.bottoms[0].floatValue;
    NSInteger column = 0;
    
    for (NSInteger i = 1; i<self.numberOfColumns; i++) {
        if (minY < self.bottoms[i].floatValue) {
            minY = self.bottoms[i].floatValue;
            column = i;
        }
    }
    
    if (completion) {
        completion(minY, column);
    }
}

- (void)getMinBottomCompletion:(void(^)(CGFloat minY, NSInteger column))completion
{
    CGFloat minY = self.bottoms[0].floatValue;
    NSInteger column = 0;
    
    for (NSInteger i = 1; i<self.numberOfColumns; i++) {
        if (minY > self.bottoms[i].floatValue) {
            minY = self.bottoms[i].floatValue;
            column = i;
        }
    }
    
    if (completion) {
        completion(minY, column);
    }
}

- (CGRect)itemFrameAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *frameKey = [self frameKeyAtIndexPath:indexPath];
    
    NSString *frameString = [self.frameDictionary objectForKey:frameKey];
    if (frameString) {
        return CGRectFromString(frameString);
    }
    
    __block CGRect f = [self randomBoundsAtIndexPath:indexPath];
    CGFloat minY = 0;
    NSInteger column = 0;
    if (indexPath.row == 0) {
        column = 1;
        f.origin.x = self.sectionInset.left;
        minY = self.headerReferenceSize.height + self.sectionInset.top;
    }else if (indexPath.row == 1 || indexPath.row == 2) {
        column = indexPath.row + 1;
        f.origin.x = self.sectionInset.left + (self.minimumInteritemSpacing+f.size.width)*(2);
        minY = self.headerReferenceSize.height + self.sectionInset.top + (indexPath.row-1)*(f.size.height + self.minimumLineSpacing);
    }else{
        
        NSInteger newColumn = (indexPath.row - 3)%3;
        column = newColumn+1;
        int row = (int)(indexPath.row - 3)/3;
        minY = self.headerReferenceSize.height + self.sectionInset.top + (f.size.height + self.minimumLineSpacing)*2 + (self.minimumLineSpacing + f.size.height)*row;
        f.origin.x = self.sectionInset.left + (self.minimumInteritemSpacing+f.size.width)*newColumn;
    }
    
    f.origin.y = minY;
    self.bottoms[column] = @(CGRectGetMaxY(f));

//    [self getMinBottomCompletion:^(CGFloat minY, NSInteger column) {
//    }];
//
    [self.frameDictionary setObject:NSStringFromCGRect(f) forKey:frameKey];
    
    return f;
}
@end
