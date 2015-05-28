
using GnomeKeyring;

[DBus (name="org.gnome.ScreenSaver")]
public interface GnomeScreenSaver : Object {

   public static const string BUS_NAME    = "org.gnome.ScreenSaver";
   public static const string OBJECT_PATH = "/org/gnome/ScreenSaver";

   public signal void active_changed(bool active);

}

public void main(string[] args) {

   GnomeScreenSaver gss = null;

   Bus.watch_name(BusType.SESSION, GnomeScreenSaver.BUS_NAME, BusNameWatcherFlags.NONE,
                  (connection, name, owner) => {
                     gss = Bus.get_proxy_sync(BusType.SESSION,
                                              GnomeScreenSaver.BUS_NAME,
                                              GnomeScreenSaver.OBJECT_PATH);

                     gss.active_changed.connect( (active) => {
                        stderr.printf ("Locking keyrings\n");
                        lock_all_sync();
                     });
                  });


   new MainLoop().run();
}
