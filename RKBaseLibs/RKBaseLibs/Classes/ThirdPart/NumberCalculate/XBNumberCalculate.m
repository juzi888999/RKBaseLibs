//
//  XBNumberCalculate.h
//  XBNumberCalculate
//
//  Created by xxx on 2018/5/29.
//  Copyright © 2019年 RKBaseLibs. All rights reserved.
//

#import "XBNumberCalculate.h"

@interface XBNumberCalculate()<UITextFieldDelegate>
/** 加 */
@property (nonatomic, strong) UIButton *addBtn;
/** 减 */
@property (nonatomic, strong) UIButton *reduceBtn;
/** 数值框 */
@property (nonatomic, strong) UITextField *numberText;
/** 记录数值 */
@property (nonatomic, copy) NSString *recordNum;

@end

#define numborderWidth 0.5

@implementation XBNumberCalculate

- (instancetype)initWithFrame:(CGRect)frame btnWidth:(CGFloat)btnWidth{
    if (self=[super initWithFrame:frame]){
        _buttonColor = [UIColor whiteColor];
        _disableButtonColor = HPColorForKey(@"#f7f7f7");
        _multipleNum=1;
        _minNum=0;
        _baseNum = @"1";
        _textColor = HPColorForKey(@"#8a8a8a");
        _btnWidth = btnWidth;
        [self updateView];
    }
    return self;
}

- (void)updateView{
    [_reduceBtn removeFromSuperview];
    [_numberText removeFromSuperview];
    [_addBtn removeFromSuperview];
    
    CGFloat viewHeight=self.frame.size.height;
    CGFloat viewWidth=self.frame.size.width;
    CGFloat btnWidth= self.btnWidth > 0 ? self.btnWidth:self.frame.size.height;
    _reduceBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, viewHeight)];
    [_reduceBtn setImage:[UIImage imageNamed:@"xb_numberCalculate_btn_minus"] forState:UIControlStateNormal];
    [_reduceBtn setBackgroundImage:[UIImage imageWithColor:self.buttonColor cornerRadius:0] forState:UIControlStateNormal];
    [_reduceBtn setBackgroundImage:[UIImage imageWithColor:self.disableButtonColor cornerRadius:0] forState:UIControlStateDisabled];
    [_reduceBtn addTarget:self action:@selector(reduceNumberClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reduceBtn];
    
    _numberText=[[UITextField alloc]initWithFrame:CGRectMake(btnWidth, 0, viewWidth-btnWidth*2, viewHeight)];
    _numberText.text=[NSString checkString:_baseNum];
    _numberText.userInteractionEnabled=YES;
    _numberText.textColor= self.textColor;
    _numberText.keyboardType = UIKeyboardTypeNumberPad;
    _numberText.textAlignment = NSTextAlignmentCenter;
    _numberText.delegate=self;
    [_numberText addTarget:self action:@selector(textNumberChange:) forControlEvents:UIControlEventEditingChanged];//
    [self addSubview:_numberText];
    
    _addBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numberText.frame), 0, btnWidth, viewHeight)];
    [_addBtn setBackgroundImage:[UIImage imageWithColor:self.buttonColor cornerRadius:0] forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageWithColor:self.disableButtonColor cornerRadius:0] forState:UIControlStateDisabled];
    [_addBtn setImage:[UIImage imageNamed:@"xb_numberCalculate_btn_add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addNumberClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    if (!_hidBorder) {
//        _reduceBtn.layer.borderWidth=numborderWidth;
//        _numberText.layer.borderWidth=numborderWidth;
//        _addBtn.layer.borderWidth=numborderWidth;
        self.layer.borderWidth = numborderWidth;
        [self.numberText addLeftLineWithTop:0 bottom:0 color:_numborderColor];
        [self.numberText addRightLineWithTop:0 bottom:0 color:_numborderColor];
        if (_numborderColor) {
//            _reduceBtn.layer.borderColor=_numborderColor.CGColor;
//            _numberText.layer.borderColor=_numborderColor.CGColor;
//            _addBtn.layer.borderColor=_numborderColor.CGColor;
            self.layer.borderColor = _numborderColor.CGColor;
        }else{
//            _reduceBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
//            _numberText.layer.borderColor=[UIColor lightGrayColor].CGColor;
//            _addBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
            self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    self.reduceBtn.enabled = [_numberText.text integerValue] > self.minNum;
    self.addBtn.enabled = [_numberText.text integerValue] < self.maxNum;
    [self bringSubviewToFront:_numberText];
}

/** 减 */
- (void)reduceNumberClick{
    [_numberText resignFirstResponder];
    
    if ([_numberText.text integerValue]<= _minNum){
        [self shakeAnimation];
        return;
    }
    
    _numberText.text=[NSString stringWithFormat:@"%ld",(long)[_numberText.text integerValue]-_multipleNum];
    
    [self callBackResultNumber:_numberText.text];
}

- (void)resetNum
{
    _numberText.text = [NSString checkString:_baseNum];
    [self callBackResultNumber:_numberText.text];
}
/** 加 */
- (void)addNumberClick{
    [_numberText resignFirstResponder];
    
    if (_numberText.text.integerValue < _maxNum) {
        _numberText.text=[NSString stringWithFormat:@"%ld",(long)[_numberText.text integerValue]+_multipleNum];
    }else{
        [self shakeAnimation];
    }
    
    [self callBackResultNumber:_numberText.text];
}

/** 数值变化 */
- (void)textNumberChange:(UITextField *)textField{
    if (textField.text.integerValue < _minNum) {
//        [self alertMessage:@"您输入的数量小于最小值，请重新输入"];
        textField.text = [NSString stringWithFormat:@"%ld",(long)_minNum];
    }
    
    if (textField.text.integerValue > _maxNum) {
//        [self alertMessage:@"您输入的数量大于最大值，请重新输入"];
        [UIGlobal showMessage:[NSString stringWithFormat:@"最多%ld倍",(long)self.maxNum]];
        textField.text = [NSString stringWithFormat:@"%ld",(long)_maxNum];
        return;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _recordNum = textField.text;
    textField.text = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        textField.text = _recordNum;
    }
    
    if (textField.text.integerValue/_multipleNum == 0) {//输入小于基本倍数值 更改为倍数数值/若想在minNum为0的情况下输入小于倍数值的时候 更改为0 增加为0时的else内判断即可（如 倍数值为3，键入1 需求更改为0数值的情况下）
        textField.text=[NSString stringWithFormat:@"%ld",_multipleNum];
    }else{
        textField.text=[NSString stringWithFormat:@"%ld",(long)(textField.text.integerValue/_multipleNum)*_multipleNum];
    }
    
    [self callBackResultNumber:textField.text];
}

- (void)callBackResultNumber:(NSString *)number{
    
    self.reduceBtn.enabled = [number integerValue] > self.minNum;
    self.addBtn.enabled = [number integerValue] < self.maxNum;
    
    if (self.resultNumber) {
        self.resultNumber(number);
    }
    
    if ([self.delegate respondsToSelector:@selector(resultNumber:)]) {
        [self.delegate resultNumber:number];
    }
}


/** 限制输入数字 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


/** 抖动动画 */
- (void)shakeAnimation
{
    if (_isShake) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        //获取当前View的position坐标
        CGFloat positionX = self.layer.position.x;
        //设置抖动的范围
        animation.values = @[@(positionX-4),@(positionX),@(positionX+4)];
        //动画重复的次数
        animation.repeatCount = 3;
        //动画时间
        animation.duration = 0.07;
        //设置自动反转
        animation.autoreverses = YES;
        [self.layer addAnimation:animation forKey:nil];
    }
}

/** setter getter */
- (void)setBaseNum:(NSString *)baseNum{
    _baseNum=baseNum;
}

- (void)setMultipleNum:(NSInteger)multipleNum{
    _multipleNum=multipleNum;
}

- (void)setCanText:(BOOL)canText{
    _canText=canText;
    _numberText.userInteractionEnabled=_canText;
}

- (void)setHidBorder:(BOOL)hidBorder{
    _hidBorder=hidBorder;
}

- (void)setNumborderColor:(UIColor *)numborderColor{
    _numborderColor=numborderColor;
}

- (void)setButtonColor:(UIColor *)buttonColor{
    _buttonColor=buttonColor;
}

- (void)setIsShake:(BOOL)isShake{
    _isShake=isShake;
}

- (void)setMinNum:(NSInteger)minNum{
    if (minNum<0) {
        minNum=0;
    }
    _minNum=minNum;
}

- (void)setMaxNum:(NSInteger)maxNum{
    _maxNum=maxNum;
}


@end
