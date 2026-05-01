import { registry }from "gulp";
import HubRegistry from "gulp-hub";

const hub = new HubRegistry(['./*/build/index.js', './www/source/*/*/build/index.js']); /* load some gulpfiles into the registry */
registry(hub); /* tell gulp to use the tasks just loaded */
