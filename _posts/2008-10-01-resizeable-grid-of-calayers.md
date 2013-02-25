---
layout: post
title: Creating a resizable grid of CALayers
featured: true
tags: [Hacks, Objective-C]
---

The last few days I've been poring over the [Core Animation Programming
Guide][coreanimation]. In particular, I've been trying to figure out how to
create a grid of equally-sized cells. My initial attempt just saw me
calculating the frames for each cell in the grid manually, and explicitly
setting the frame for each cell. This worked, after a fashion, but was
pretty ugly. And, if I resized the grid the cells didn't follow.

[coreanimation]: http://developer.apple.com/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html

Enter [CAConstraintLayoutManager][]. I initially tried to constrain each
cell to neighbouring cells, and to the super layer for the "outer" cells.
Not only was this messy; I [couldn't make it
work](http://lists.apple.com/archives/quartz-dev/2008/Sep/msg00044.html) at
all—not even with a 1 by 5 "grid". I suspect that the layout manager is
getting a bit confused because I don't specify the size of any dimension of
any cell.

[caconstraintlayoutmanager]: http://developer.apple.com/documentation/GraphicsImaging/Reference/CAConstraintLayoutManager_class/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004498-CH1

Then I discovered the scale-argument form of the `NSConstraint`. With this I
can specify the size of a cell and its position in the grid only in terms of the super
layer. This is *much* simpler. Have a look at the example code below. Paste it into a
custom view, and it should display a gray grid on a pleasant blue background:

{% highlight objc %}
- (void)awakeFromNib {
    self.wantsLayer = YES;
    CALayer *grid = self.layer;

    grid.backgroundColor = CGColorCreateGenericRGB(0.1, 0.1, 0.4, .8);
    grid.layoutManager = [CAConstraintLayoutManager layoutManager];

    int rows = 8;
    int columns = 8;

    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < columns; c++) {
            CALayer *cell = [CALayer layer];
            cell.borderColor = CGColorCreateGenericGray(0.8, 0.8);
            cell.borderWidth = 1;
            cell.cornerRadius = 4;
            cell.name = [NSString stringWithFormat:@"%u@%u", c, r];

            [cell addConstraint:
             [CAConstraint constraintWithAttribute: kCAConstraintWidth
                                        relativeTo: @"superlayer"
                                         attribute: kCAConstraintWidth
                                             scale: 1.0 / columns
                                            offset: 0]];

            [cell addConstraint:
             [CAConstraint constraintWithAttribute: kCAConstraintHeight
                                        relativeTo: @"superlayer"
                                         attribute: kCAConstraintHeight
                                             scale: 1.0 / rows
                                            offset: 0]];

            [cell addConstraint:
             [CAConstraint constraintWithAttribute: kCAConstraintMinX
                                        relativeTo: @"superlayer"
                                         attribute: kCAConstraintMaxX
                                             scale: c / (float)columns
                                            offset: 0]];

            [cell addConstraint:
             [CAConstraint constraintWithAttribute: kCAConstraintMinY
                                        relativeTo: @"superlayer"
                                         attribute: kCAConstraintMaxY
                                             scale: r / (float)rows
                                            offset: 0]];

            [grid addSublayer:cell];
        }
    }
}
{% endhighlight %}

<del>Things aren't so simple if you want to have some spacing between the
cells. I suspect you have to pack a cell within an intermediate CALayer, or
add some custom drawing to each cell to draw the border a bit inset from the
edge of the cell.</del>

**Update:** It turns out that using this method to create a grid with spacing between the
cells is not much harder after all. The below replacements for the constraints above give
you a 2-pixel spacing between the tiles. The differences are in the negative offsets and
adding the 0.5 to c & r in the scale:

{% highlight objc %}
[cell addConstraint:
 [CAConstraint constraintWithAttribute: kCAConstraintWidth
                            relativeTo: @"superlayer"
                             attribute: kCAConstraintWidth
                                 scale: 1.0 / columns
                                offset: -2]];

[cell addConstraint:
 [CAConstraint constraintWithAttribute: kCAConstraintHeight
                            relativeTo: @"superlayer"
                             attribute: kCAConstraintHeight
                                 scale: 1.0 / rows
                                offset: -2]];

[cell addConstraint:
 [CAConstraint constraintWithAttribute: kCAConstraintMidX
                            relativeTo: @"superlayer"
                             attribute: kCAConstraintMaxX
                                 scale: (c + 0.5) / (float)columns
                                offset: 0]];

[cell addConstraint:
 [CAConstraint constraintWithAttribute: kCAConstraintMidY
                            relativeTo: @"superlayer"
                             attribute: kCAConstraintMaxY
                                 scale: (r + 0.5) / (float)rows
                                offset: 0]];
{% endhighlight %}
