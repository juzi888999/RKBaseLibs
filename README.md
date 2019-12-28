# RKBaseLibs
app的Object-C基础框架
支持cocoapod
pod 'RKBaseLibs'



HMSegmentController 自定义样式

- (void)addSegmentView
{
    if (self.segmentControl) {
        [self.segmentControl removeAllSubviews];
        [self.segmentControl removeFromSuperview];
        self.segmentControl = nil;
    }
    
    //    if (self.moreBtn) {
    //        [self.moreBtn removeFromSuperview];
    //        self.moreBtn = nil;
    //    }
    
    if (!self.segmentControl) {
        HMSegmentedControl * segment = [[HMSegmentedControl alloc] initWithSectionItems:self.model.listData customViewBlock:^UIView *(XBMoreGamesPagingEntity * item, NSInteger index) {
            
            UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemBtn setTitleColor:HPColorForKey(@"#666666") forState:UIControlStateNormal];
            [itemBtn setTitleColor:HPColorForKey(@"#f42023") forState:UIControlStateSelected];
            [itemBtn setTitle:item.name forState:UIControlStateNormal];
            if ([item.name isEqualToString:@"全部"]) {
                [itemBtn setImage:HPImageForKey(item.imageBlack) forState:UIControlStateNormal];
                [itemBtn setImage:HPImageForKey(item.image) forState:UIControlStateSelected];
            }else{
                [itemBtn sd_setImageWithURL:[NetworkClient imageUrlForString:item.imageBlack] forState:UIControlStateNormal];
                [itemBtn sd_setImageWithURL:[NetworkClient imageUrlForString:item.image] forState:UIControlStateSelected];
            }
            itemBtn.titleLabel.font = HPFontWithSize(14);
            itemBtn.userInteractionEnabled = NO;
            itemBtn.lx_layoutType = LXButtonLayoutTypeImageTop;
            itemBtn.lx_subMargin = 2;
            itemBtn.lx_imageViewSize = CGSizeMake(28, 28);
            return itemBtn;
        }];
        segment.minSegmentWidth = 74;
        segment.backgroundColor = HPColorForKey(@"#ffffff");
        segment.selectionIndicatorHeight = 2;
//        segment.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
        segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segment.selectionIndicatorColor = HPColorForKey(@"#f42023");
        self.segmentControl = segment;
        segment.layer.shadowColor = UIColor.blackColor.CGColor;
        segment.layer.shadowOffset = CGSizeMake(0, 0.5);
        segment.layer.shadowOpacity = 0.5;
        
        [segment setSelectedStyleBlock:^(NSArray *views, NSInteger selectedIndex) {
            int i = 0;
            for (UIButton * itemBtn in views) {
                itemBtn.selected = i == selectedIndex;
                i ++;
            }
        }];
        @weakify(self);
        [segment setTapAtIndexBlock:^(NSInteger index) {
            @strongify(self);
            if (self) {            
                [self.segmentControl setSelectedSegmentIndex:index animated:YES];
                [self.pagingScrollView moveToPageAtIndex:index animated:NO];
            }
        }];
        
        [self.view addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo([self segmentHeight]);
        }];
    }
  
}
