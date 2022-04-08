using Gtk;

namespace AreaScreenshot {

/**
 * Interface to the Gnome Shell screenshot service
 **/
[DBus (name="org.gnome.Shell.Screenshot")]
public interface GnomeScreenshot : Object {

   public static const string BUS_NAME    = "org.gnome.Shell.Screenshot";
   public static const string OBJECT_PATH = "/org/gnome/Shell/Screenshot";

   public signal void active_changed(bool active);

   public abstract void select_area(out int32 x,
                                    out int32 y,
                                    out int32 height,
                                    out int32 width) throws IOError;

   public abstract void screenshot_area(int32 x,
                                        int32 y,
                                        int32 height,
                                        int32 width,
                                        bool flash,
                                        string filename,
                                        out bool success,
                                        out string filenameUsed) throws IOError;

}


[DBus (name="org.wrowclif.AreaScreenshot")]
public class AreaScreenshot : Object {

   public static const string BUS_NAME    = "org.wrowclif.AreaScreenshot";
   public static const string OBJECT_PATH = "/org/wrowclif/AreaScreenshot";

   public AreaScreenshot() {
   }

   public void screenshot(out bool success, out string filenameUsed) {
      success = false;
      filenameUsed = null;


      int32 x;
      int32 y;
      int32 width;
      int32 height;

      stderr.printf("Starting screenshot\n");

      GnomeScreenshot screenshot = Bus.get_proxy_sync(BusType.SESSION,
                                                        GnomeScreenshot.BUS_NAME,
                                                        GnomeScreenshot.OBJECT_PATH);

      screenshot.select_area(out x, out y, out width, out height);

      stderr.printf("Got area\n");

      var filename = new DateTime.now().format("Screenshot from %F %H-%M-%S.webm");

      screenshot.screenshot_area(x, y, width, height, true, filename,
                                 out success, out filenameUsed);

      if(success) {
         var path = GLib.File.new_for_path(filenameUsed);

         Gtk.RecentManager.get_default().add_item(path.get_uri());
      }

      stderr.printf("Took screenshot: %s\n", filenameUsed);
   }

}

void main(string[] args) {
   Gtk.init(ref args);
   Bus.own_name(BusType.SESSION, AreaScreenshot.BUS_NAME, BusNameOwnerFlags.NONE,
            (c) => {
               c.register_object(AreaScreenshot.OBJECT_PATH,
                                 new AreaScreenshot());
            },
            () => {},
            () => stderr.printf ("Could not aquire name\n"));

   new MainLoop().run();
}

}
