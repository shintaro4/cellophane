#include "ofApp.h"
#include "Environment.h"


// quick & dirty hack for openFrameworks 0.8.4 on Xcode
// https://github.com/openframeworks/openFrameworks/issues/3178
// http://forum.openframeworks.cc/t/xcode6-beta-of-0-8-1-for-ios-8-0/16103/
extern "C"{
  size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
  {
    return fwrite(a, b, c, d);
  }
  char* strerror$UNIX2003( int errnum )
  {
    return strerror(errnum);
  }
  time_t mktime$UNIX2003(struct tm * a)
  {
    return mktime(a);
  }
  double strtod$UNIX2003(const char * a, char ** b) {
    return strtod(a, b);
  }
}


int main() {
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

  // language environment
  cellophane::Environment::Languages lang = cellophane::Environment::kEnglish;
  if ([[NSLocale preferredLanguages] count] > 0 &&
      [[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ja"]) {
    lang = cellophane::Environment::kJapanese;
  }
  
  // display environment (for iPhone only)
  float width = [[UIScreen mainScreen] bounds].size.width;
  float height = [[UIScreen mainScreen] bounds].size.height;
  bool is_retina = false;
  if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
    if ([[UIScreen mainScreen] scale] > 1.0) {  // Retina Display
      is_retina = true;
      width *= 2;
      height *= 2;
    }
  }
  [pool release];

  ofPtr<ofAppiOSWindow> ios_window(new ofAppiOSWindow());
  ios_window->enableRendererES1();
  if (is_retina) ios_window->enableRetina();
  ios_window->enableAntiAliasing(4);
  ofSetupOpenGL(ios_window, width, height, OF_FULLSCREEN);

  cellophane::Environment::getInstance().init(is_retina, width, height, lang);

  ofRunApp(new cellophane::ofApp());
}
