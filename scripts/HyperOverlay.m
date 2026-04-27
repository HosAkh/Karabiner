#import <Cocoa/Cocoa.h>

int main(void) {
  @autoreleasepool {
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];

    NSScreen *screen = [NSScreen mainScreen] ?: [[NSScreen screens] firstObject];
    NSRect visibleFrame = screen ? [screen visibleFrame] : NSMakeRect(0, 0, 1440, 900);
    NSSize size = NSMakeSize(180, 48);
    NSPoint origin = NSMakePoint(NSMidX(visibleFrame) - size.width / 2, NSMinY(visibleFrame) + 72);

    NSPanel *panel = [[NSPanel alloc]
      initWithContentRect:NSMakeRect(origin.x, origin.y, size.width, size.height)
      styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskNonactivatingPanel
      backing:NSBackingStoreBuffered
      defer:NO];

    [panel setLevel:NSStatusWindowLevel];
    [panel setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
                                 NSWindowCollectionBehaviorFullScreenAuxiliary |
                                 NSWindowCollectionBehaviorStationary];
    [panel setBackgroundColor:[NSColor clearColor]];
    [panel setOpaque:NO];
    [panel setHasShadow:NO];
    [panel setIgnoresMouseEvents:YES];

    NSView *container = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
    [container setWantsLayer:YES];
    [[container layer] setCornerRadius:14.0];
    [[container layer] setBackgroundColor:[[NSColor colorWithCalibratedWhite:0.0 alpha:0.72] CGColor]];

    NSTextField *label = [NSTextField labelWithString:@"hyper"];
    [label setFont:[NSFont systemFontOfSize:24.0 weight:NSFontWeightSemibold]];
    [label setTextColor:[NSColor whiteColor]];
    [label setAlignment:NSTextAlignmentCenter];
    [label setFrame:NSInsetRect([container bounds], 16, 8)];
    [label setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    [container addSubview:label];
    [panel setContentView:container];
    [panel orderFrontRegardless];

    [NSApp run];
  }

  return 0;
}
