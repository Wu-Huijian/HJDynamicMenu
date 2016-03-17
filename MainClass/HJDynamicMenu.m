//
//  HJDynamicMenu.m
//  HJDynamicMenu
//
//  Created by WHJ on 16/3/15.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJDynamicMenu.h"



@interface HJDynamicMenu ()<UICollisionBehaviorDelegate>{
    BOOL expland;
    NSArray *optionColors;
    NSArray *optionImages;
    NSArray *optionTexts;
}

@property (nonatomic, strong) UIDynamicAnimator * animator;
@property (nonatomic ,assign)CGPoint startPoint;
@property (nonatomic ,strong)NSMutableArray *snaps;
@property (nonatomic ,strong)UICollisionBehavior *collision;
@property (nonatomic ,strong)UIDynamicItemBehavior *itemBehavior;


@property (nonatomic ,strong)id<UIDynamicItem> bumper;


@end


@implementation HJDynamicMenu




-(instancetype)initWithPoint:(CGPoint)point width:(CGFloat)width{
    self = [super initWithFrame:CGRectMake(0, 0, width, width)];
    if(self){
        self.center = point;
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = width/2.f;
        self.layer.masksToBounds = YES;
        self.startPoint = point;
        [self initW];
    }
    return self;

}


-(instancetype)initWithPoint:(CGPoint)point width:(CGFloat)width
               customItems:(NSArray *)items;{
    self = [super initWithFrame:CGRectMake(0, 0, width, width)];
    if (self) {
        self.items =  [NSMutableArray arrayWithArray:items];
    }
    return self;
}

-(instancetype)initWithPoint:(CGPoint)point width:(CGFloat)width
                               optionColors:(NSArray *)colors
                optionBackgroundImages:(NSArray *)images
                                 texts:(NSArray *)texts{
    
    self = [self initWithPoint:point width:width];
    if (self) {
        optionColors = colors;
        optionImages = images;
        optionTexts  = texts;
    }
    return self;
}



-(void)initW{
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.superview];
    self.snaps = [NSMutableArray array];
}




-(void)setupUI{
    for(int i=0;i<self.positions.count;i++){
        UIView *view;
        if (_items.count==_positions.count) {
            view = self.items[i];
        }else{
            if (optionTexts!=nil) {
                view = [self createButtonWithText:optionTexts[i]];
            }else{
                view = [self createButtonWithText:@""];
            }
            UIButton *btn = (UIButton *)view;
            if (optionColors!=nil) {
                btn.backgroundColor = optionColors[i];
            }else{
                btn.backgroundColor = [UIColor redColor];
            }
            
            if (optionImages!=nil) {
                [btn setImage:optionImages[i] forState:UIControlStateNormal];
            }
            [self.items addObject:view];
        }
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [view addGestureRecognizer:pan];

        
        UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:view snapToPoint:[self.positions[i] CGPointValue]];
        [self.superview addSubview:view];
        [self.snaps addObject:snap];
    }
    
    [self.superview bringSubviewToFront:self];
    
    
    self.collision = [[UICollisionBehavior alloc]initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = YES;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.3;

}


-(void)didMoveToSuperview{
    [self setupUI];
}



-(UIButton *)createButtonWithText:(NSString *)text{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    button.layer.cornerRadius = button.frame.size.width/2.f;
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.center = _startPoint;
    return button;
}


-(void)panAction:(UIPanGestureRecognizer *)gesture{
    
    UIView *touchView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self removeSnapBehaviors];
        [self.animator removeBehavior:self.collision];
        [self.animator removeBehavior:self.itemBehavior];
        self.bumper = touchView;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
     NSInteger index = [self.items indexOfObject:touchView];
        if(index != NSNotFound){
        [self.animator addBehavior:self.snaps[index]];
        [self.animator addBehavior:self.collision];
        [self.animator addBehavior:self.itemBehavior];
        }
    }
}


-(void)removeSnapBehaviors{
    [self.snaps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.animator removeBehavior:obj];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    if (expland) {
        [self shrinkOptions];
    }else{
        [self explandOptions];
    }
    expland = !expland;
}


-(void)shrinkOptions{
    [self removeSnapBehaviors];
    [self.snaps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UISnapBehavior *snap = obj;
        snap.snapPoint = _startPoint;
        [self.animator addBehavior:snap];
        [self.animator removeBehavior:self.collision];
    }];
}



-(void)explandOptions{
    [self removeSnapBehaviors];
    [self.snaps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UISnapBehavior *snap = self.snaps[idx];
        snap.snapPoint = [_positions[idx] CGPointValue];
        [self.animator addBehavior:snap];
    }];
}



-(void)snapToPostionsWithIndex:(NSInteger)index{
     UISnapBehavior *snap = self.snaps[index];
    [self.animator addBehavior:snap];
}




#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{   //reback
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}


#pragma mark - setters/getters
-(NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


-(NSArray *)positions{
    if (_positions == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<optionTexts.count; i++) {
            [array addObject:[NSValue valueWithCGPoint:_startPoint]];
        }
        _positions = [NSArray arrayWithArray:array];
    }
    return _positions;
}

@end
