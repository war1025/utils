/*
 * Copyright © 2013 Wayne Rowcliffe <war1025@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Alternatively, you can redistribute and/or modify this program under the
 * same terms that the “gnome-shell” or “gnome-shell-extensions” software
 * packages are being distributed by The GNOME Project.
 *
 */


const Gio = imports.gi.Gio;
const Main = imports.ui.main;
const GLib = imports.gi.GLib;


function enable() {
   GLib.timeout_add_seconds(
      GLib.PRIORITY_DEFAULT,
      10,
      () => {
         Main.shellDBusService._screenshotService._senderChecker = {
            "checkInvocation" : function(){}
         };

         return false;
      }
   );
}

function disable() {
}
