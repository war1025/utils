
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

   private GLib.HashTable<string, GLib.Variant> options;

   private bool recording;

   public AreaScreencast() {

      options = new GLib.HashTable<string, GLib.Variant>(null, null);

      options["pipeline"] = "vp8enc min_quantizer=13 max_quantizer=13 cpu-used=5 deadline=1000000 threads=%T ! queue ! webmmux";

      recording = false;

   }

   public void start_screencast(out bool success, out string filenameUsed) {
      success = false;
      filenameUsed = null;


      int32 x;
      int32 y;
      int32 width;
      int32 height;

      stderr.printf("Starting screencast\n");

      GnomeScreenshot screenshot = Bus.get_proxy_sync(BusType.SESSION,
                                                        GnomeScreenshot.BUS_NAME,
                                                        GnomeScreenshot.OBJECT_PATH);

      screenshot.select_area(out x, out y, out width, out height);

      stderr.printf("Got area\n");

      GnomeScreencast screencast = Bus.get_proxy_sync(BusType.SESSION,
                                      GnomeScreencast.BUS_NAME,
                                      GnomeScreencast.OBJECT_PATH);

      screencast.screencast_area(x, y, width, height, "Screencast from %d %t.webm", this.options,
                                 out success, out filenameUsed);

      this.recording = success;

      stderr.printf("Started screencast\n");
   }

   public void stop_screencast(out bool success) {
      success = false;

      GnomeScreencast screencast = Bus.get_proxy_sync(BusType.SESSION,
                                      GnomeScreencast.BUS_NAME,
                                      GnomeScreencast.OBJECT_PATH);

      screencast.stop_screencast(out success);

      stderr.printf("Stopped screencast\n");

      this.recording = false;
   }

   public void toggle_screencast(out bool recording) {
      bool success;
      string filename;

      if (this.recording) {
         this.stop_screencast(out success);
      } else {
         this.start_screencast(out success, out filename);
      }

      recording = this.recording;
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
