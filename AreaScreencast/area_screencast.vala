
namespace AreaScreencast {

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

}


/**
 * Interface to the Gnome Shell screencast service
 **/
[DBus (name="org.gnome.Shell.Screencast")]
public interface GnomeScreencast : Object {

   public static const string BUS_NAME    = "org.gnome.Shell.Screencast";
   public static const string OBJECT_PATH = "/org/gnome/Shell/Screencast";

   public abstract void screencast_area(int32 x,
                                        int32 y,
                                        int32 height,
                                        int32 width,
                                        string templateName,
                                        GLib.HashTable<string, GLib.Variant> options,
                                        out bool success,
                                        out string filenameUsed) throws IOError;

   public abstract void stop_screencast(out bool success) throws IOError;
}

[DBus (name="org.wrowclif.AreaScreencast")]
public class AreaScreencast : Object {

   public static const string BUS_NAME    = "org.wrowclif.AreaScreencast";
   public static const string OBJECT_PATH = "/org/wrowclif/AreaScreencast";

   private GnomeScreencast screencast;
   private GnomeScreenshot screenshot;

   private GLib.HashTable<string, GLib.Variant> options;

   public AreaScreencast() {
      Bus.watch_name(BusType.SESSION, GnomeScreencast.BUS_NAME, BusNameWatcherFlags.NONE,
                     (connection, name, owner) => {
                        screencast = Bus.get_proxy_sync(BusType.SESSION,
                                                        GnomeScreencast.BUS_NAME,
                                                        GnomeScreencast.OBJECT_PATH);
                     });

      Bus.watch_name(BusType.SESSION, GnomeScreenshot.BUS_NAME, BusNameWatcherFlags.NONE,
                     (connection, name, owner) => {
                        screenshot = Bus.get_proxy_sync(BusType.SESSION,
                                                        GnomeScreenshot.BUS_NAME,
                                                        GnomeScreenshot.OBJECT_PATH);
                     });

      options = new GLib.HashTable<string, GLib.Variant>(null, null);

   }

   public void start_screencast(out bool success, out string filenameUsed) {
      success = false;
      filenameUsed = null;

      if (screencast == null || screenshot == null) {
         return;
      }

      int32 x;
      int32 y;
      int32 width;
      int32 height;

      stderr.printf("Starting screencast\n");

      screenshot.select_area(out x, out y, out width, out height);

      stderr.printf("Got area\n");

      screencast.screencast_area(x, y, width, height, "Screencast from %d %t.webm", this.options,
                                 out success, out filenameUsed);

      stderr.printf("Started screencast\n");
   }

   public void stop_screencast(out bool success) {
      success = false;

      if (screencast == null) {
         return;
      }

      screencast.stop_screencast(out success);

      stderr.printf("Stopped screencast\n");
   }

}

void main() {
   Bus.own_name(BusType.SESSION, AreaScreencast.BUS_NAME, BusNameOwnerFlags.NONE,
            (c) => {
               c.register_object(AreaScreencast.OBJECT_PATH,
                                 new AreaScreencast());
            },
            () => {},
            () => stderr.printf ("Could not aquire name\n"));

   new MainLoop().run();
}

}