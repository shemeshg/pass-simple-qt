/*
 *  Copyright (C) 2016 Lennart Glauer <mail@lennart-glauer.de>
 *  Copyright (C) 2017 KeePassXC Team <team@keepassxc.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 or (at your option)
 *  version 3 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "AppKitImpl.h"
#include <QMainWindow>
#import <QWindow>
#import <Cocoa/Cocoa.h>

@implementation AppKitImpl

- (id) initWithObject:(AppKit*)appkit
{
    self = [super init];

    if (self) {
        m_appkit = appkit;
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(didDeactivateApplicationObserver:)
                                                               name:NSWorkspaceDidDeactivateApplicationNotification
                                                             object:nil];
    
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                            selector:@selector(userSwitchHandler:)
                                                                name:NSWorkspaceSessionDidResignActiveNotification
                                                                object:nil];

        [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:NSKeyValueObservingOptionNew context:nil];

        // Unfortunately, there is no notification for a wallpaper change, which affects
        // the status bar colour on macOS Big Sur, but we can at least subscribe to this.
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(interfaceThemeChanged:)
                                                                name:@"AppleColorPreferencesChangedNotification"
                                                              object:nil];

    }
    return self;
}

//
// Update last active application property
//
- (void) didDeactivateApplicationObserver:(NSNotification*) notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSRunningApplication* app = [userInfo objectForKey:NSWorkspaceApplicationKey];

    if (app.processIdentifier != [self ownProcessId]) {
        self.lastActiveApplication = app;
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    Q_UNUSED(object)
    Q_UNUSED(change)
    Q_UNUSED(context)
    if ([keyPath isEqualToString:@"effectiveAppearance"]) {
        if (m_appkit) {

            void (^emitBlock)(void) = ^{
                emit m_appkit->interfaceThemeChanged();
            };

            if(@available(macOS 11.0, *)) {
                // Not sure why exactly this call is needed, but Apple sample code uses it so it's best to use it here too
                [NSApp.effectiveAppearance performAsCurrentDrawingAppearance:emitBlock];
            }
            else {
                emitBlock();
            }
        }
    }
}


//
// Get process id of frontmost application (-> keyboard input)
//
- (pid_t) activeProcessId
{
    return [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;
}

//
// Get process id of own process
//
- (pid_t) ownProcessId
{
    return [NSProcessInfo processInfo].processIdentifier;
}

/*
//
// Activate application by process id
//
- (bool) activateProcess:(pid_t) pid
{
    NSRunningApplication* app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    return [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}
*/

//
// Hide application by process id
//
- (bool) hideProcess:(pid_t) pid
{
    NSRunningApplication* app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    return [app hide];
}

//
// Get application hidden state by process id
//
- (bool) isHidden:(pid_t) pid
{
    NSRunningApplication* app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    return [app isHidden];
}

//
// Get state of macOS Dark Mode color scheme
//
- (bool) isDarkMode
{
    return [NSApp.effectiveAppearance.name isEqualToString:NSAppearanceNameDarkAqua];
}


//
// Get global menu bar theme state
//
- (bool) isStatusBarDark
{
#if __clang_major__ >= 9 && MAC_OS_X_VERSION_MIN_REQUIRED >= 101000
    if (@available(macOS 10.17, *)) {
        // This is an ugly hack, but I couldn't find a way to access QTrayIcon's NSStatusItem.
        NSStatusItem* dummy = [[NSStatusBar systemStatusBar] statusItemWithLength:0];
        NSString* appearance = [dummy.button.effectiveAppearance.name lowercaseString];
        [[NSStatusBar systemStatusBar] removeStatusItem:dummy];
        return [appearance containsString:@"dark"];
    }
#endif

    return [self isDarkMode];
}

//
// Notification for user switch
//
- (void) userSwitchHandler:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:NSWorkspaceSessionDidResignActiveNotification] && m_appkit)
    {
        emit m_appkit->lockDatabases();
    }
}

//
// Check if accessibility is enabled, may show an popup asking for permissions
//
- (bool) enableAccessibility
{
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1090
    // Request accessibility permissions for Auto-Type type on behalf of the user
    NSDictionary* opts = @{static_cast<id>(kAXTrustedCheckOptionPrompt): @YES};
    return AXIsProcessTrustedWithOptions(static_cast<CFDictionaryRef>(opts));
#else
    return YES;
#endif
}

/*
//
// Check if screen recording is enabled, may show an popup asking for permissions
//
- (bool) enableScreenRecording
{
#if __clang_major__ >= 9 && MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
    if (@available(macOS 10.15, *)) {
        // Request screen recording permission on macOS 10.15+
        // This is necessary to get the current window title
        CGDisplayStreamRef stream = CGDisplayStreamCreate(CGMainDisplayID(), 1, 1, kCVPixelFormatType_32BGRA, nil,
                                                          ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, 
                                                                  IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef) {
                                                              Q_UNUSED(status);
                                                              Q_UNUSED(displayTime);
                                                              Q_UNUSED(frameSurface);
                                                              Q_UNUSED(updateRef);
                                                          });
        if (stream) {
            CFRelease(stream);
        } else {
            return NO;
        }
    }
#endif
    return YES;
}
*/

- (void) toggleForegroundApp:(bool) foreground
{
    if (foreground) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    } else {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    }
}

- (void) setWindowSecurity:(NSWindow*) window state:(bool) state
{
    [window setSharingType: state ? NSWindowSharingNone : NSWindowSharingReadOnly];
}

- (void)autoTypeString:(NSString *)string
{
    // Simulate typing each character in the string
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        
        // Create and post the key down event
        CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)0, true);
        CGEventSetFlags(keyDown, kCGEventFlagMaskAlphaShift);
        CGEventKeyboardSetUnicodeString(keyDown, 1, &c);
        CGEventPost(kCGAnnotatedSessionEventTap, keyDown);
        CFRelease(keyDown);
        
        // Create and post the key up event
        CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)0, false);
        CGEventSetFlags(keyUp, kCGEventFlagMaskAlphaShift);
        CGEventKeyboardSetUnicodeString(keyUp, 1, &c);
        CGEventPost(kCGAnnotatedSessionEventTap, keyUp);
        CFRelease(keyUp);
    }  
}

@end

//
// ------------------------- C++ Trampolines -------------------------
//

AppKit::AppKit(QObject* parent)
    : QObject(parent)
{
    self = [[AppKitImpl alloc] initWithObject:this];
}

AppKit::~AppKit()
{
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:static_cast<id>(self)];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:static_cast<id>(self)];
    [NSApp removeObserver:static_cast<id>(self) forKeyPath:@"effectiveAppearance"];
    [static_cast<id>(self) dealloc];
}

pid_t AppKit::lastActiveProcessId()
{
    return [static_cast<id>(self) lastActiveApplication].processIdentifier;
}

pid_t AppKit::activeProcessId()
{
    return [static_cast<id>(self) activeProcessId];
}

pid_t AppKit::ownProcessId()
{
    return [static_cast<id>(self) ownProcessId];
}

/*
bool AppKit::activateProcess(pid_t pid)
{
    return [static_cast<id>(self) activateProcess:pid];
}
*/

bool AppKit::hideProcess(pid_t pid)
{
    return [static_cast<id>(self) hideProcess:pid];
}

bool AppKit::isHidden(pid_t pid)
{
    return [static_cast<id>(self) isHidden:pid];
}

bool AppKit::isDarkMode()
{
    return [static_cast<id>(self) isDarkMode];
}

bool AppKit::isStatusBarDark()
{
    return [static_cast<id>(self) isStatusBarDark];
}


bool AppKit::enableAccessibility()
{
    return [static_cast<id>(self) enableAccessibility];
}

/*
bool AppKit::enableScreenRecording()
{
    return [static_cast<id>(self) enableScreenRecording];
}
*/

void AppKit::toggleForegroundApp(bool foreground)
{
    [static_cast<id>(self) toggleForegroundApp:foreground];
}



void AppKit::setWindowSecurity(unsigned long long winId, bool state)
{
    auto view = reinterpret_cast<NSView *>(winId);
    [static_cast<id>(self) setWindowSecurity:view.window state:state];
}


void AppKit::autoTypeString(const std::string& str)
{
    NSString *string = [NSString stringWithUTF8String:str.c_str()];
    [static_cast<id>(self) autoTypeString:string];
}

